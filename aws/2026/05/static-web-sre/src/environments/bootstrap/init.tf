# Terraform # 필수 Provider의 요구 조건 설정
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Terraform # AWS Provider
provider "aws" {
  region = var.region
}


# S3 # Terraform State 를 저장할 Bucket. 생성 이후 
resource "aws_s3_bucket" "static_web_sre-state_storage" {
  bucket = var.bucket_name
  region = var.region
  tags   = var.env_bootstrap
}
# S3 # Bucket Versioning 활성화
resource "aws_s3_bucket_versioning" "static_web_sre-enable_versioning" {
  # Versioning을 활성화 할 Bucket 지정
  bucket = aws_s3_bucket.static_web_sre-state_storage.id

  # Bucket Versioning 활성화
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 # Bucket Policy 적용
resource "aws_s3_bucket_policy" "allow_save" {
  bucket = aws_s3_bucket.static_web_sre-state_storage.id
  policy = templatefile("./iam/policy_docs/bootstrap/s3_state_storage.json", { dev_role = aws_iam_role.github_action-dev.arn, prod_role = aws_iam_role.github_action-prod.arn, state_bucket = aws_s3_bucket.static_web_sre-state_storage.arn })
}

# S3 # Dev, Prod Branch가 사용할 디랙토리 생성
# Dev
resource "aws_s3_object" "dev_directory" {
  bucket = aws_s3_bucket.static_web_sre-state_storage.id
  key    = "dev/"
}
# Prod
resource "aws_s3_object" "prod_directory" {
  bucket = aws_s3_bucket.static_web_sre-state_storage.id
  key    = "prod/"
}


# IAM # Github Action이 사용할 IAM OIDC Connector
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = var.client_id_list
  thumbprint_list = var.thumbprint_list

  tags = var.env_bootstrap
}

# IAM # IAM Role 생성. "github_action-dev"
resource "aws_iam_role" "github_action-dev" {
  name               = var.iam_name-dev
  assume_role_policy = templatefile("./iam/role/dev/trust_github_action.json", { oidc_providers = aws_iam_openid_connect_provider.github.arn, git_org = var.git_org, git_repo = var.git_repo })

  tags = var.env_bootstrap
}
# IAM 정책 문서 생성 "github_action-dev"
resource "aws_iam_policy" "github_action-dev" {
  name        = "github_action-dev"
  description = "Let github action access S3 Bucket"
  policy      = templatefile("./iam/policy_docs/dev/github_action.json", { aws_s3_arn = aws_s3_bucket.static_web_sre-state_storage.arn, dev_bucket_arn = aws_s3_bucket.static_web_sre-dev.arn })

  tags = var.env_bootstrap
}
# IAM 정책 문서 연결
resource "aws_iam_policy_attachment" "github_action-dev" {
  name       = "github-action-dev"
  roles      = [aws_iam_role.github_action-dev.name]
  policy_arn = aws_iam_policy.github_action-dev.arn
}

# IAM # IAM Role 생성. "github_action-prod"
resource "aws_iam_role" "github_action-prod" {
  name               = var.iam_name-prod
  assume_role_policy = templatefile("./iam/role/prod/trust_github_action.json", { oidc_providers = aws_iam_openid_connect_provider.github.arn, git_org = var.git_org, git_repo = var.git_repo })
}
# IAM 정책 문서 생성 "github_action-prod"
resource "aws_iam_policy" "github_action-prod" {
  name        = "github_action-prod"
  description = "Let github action access S3 Bucket"
  policy      = templatefile("./iam/policy_docs/prod/github_action.json", { aws_s3_arn = aws_s3_bucket.static_web_sre-state_storage.arn, prod_bucket_arn = aws_s3_bucket.static_web_sre-prod.arn })

  tags = var.env_bootstrap
}
# IAM 정책 문서 연결
resource "aws_iam_policy_attachment" "github_action-prod" {
  name       = "github-action-prod"
  roles      = [aws_iam_role.github_action-prod.name]
  policy_arn = aws_iam_policy.github_action-prod.arn
}

### 정적 웹사이트 구성

# S3 # 'dev'용 정적 웹사이트 Bucket
resource "aws_s3_bucket" "static_web_sre-dev" {
  bucket = var.dev_web_bucket_name
  region = var.region
  tags = {
    Environment = "Development"
    IaCTool     = "Terraform"
  }
}
# S3 객체 소유권 설정
resource "aws_s3_bucket_ownership_controls" "static_web_sre-dev" {
  bucket = aws_s3_bucket.static_web_sre-dev.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Bucket Public Access 접근 허용
resource "aws_s3_bucket_public_access_block" "static_web_sre-dev" {
  bucket = aws_s3_bucket.static_web_sre-dev.id

  # 인터넷을 통한 외부 접근 허용. 단, 내부에 뭐가 있는지는 볼 수 없게하기
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
  depends_on              = [aws_s3_bucket_ownership_controls.static_web_sre-dev]
}

# S3 Bucket에 사용할 웹 서버 페이지 객체 생성
resource "aws_s3_object" "index_page" {
  bucket = aws_s3_bucket.static_web_sre-dev.id
  key    = "index.html"
  # 객체 컨텐츠 설정
  content_base64 = "PCFET0NUWVBFIGh0bWw+DQo8aHRtbD4NCjxoZWFkPg0KPHRpdGxlPkRldiBQYWdlPC90aXRsZT4NCjwvaGVhZD4NCjxib2R5Pg0KDQo8aDE+VGVzdGluZyBQYWdlPC9oMT4NCg0KPC9ib2R5Pg0KPC9odG1sPg=="
  content_type   = "text/html"

  depends_on = [aws_s3_bucket_ownership_controls.static_web_sre-dev]
}

# Bucket Website 구성
resource "aws_s3_bucket_website_configuration" "dev" {
  bucket = aws_s3_bucket.static_web_sre-dev.id
  # 지정된 기본 페이지 위치
  index_document {
    suffix = "index.html"
  }
  #에러 페이지
  error_document {
    key = "error.html"
  }
}

# Bucket Policy 설정
resource "aws_s3_bucket_policy" "dev" {
  bucket = aws_s3_bucket.static_web_sre-dev.id
  policy = templatefile("./iam/policy_docs/bootstrap/dev_bucket.json", { dev_role_arn = aws_iam_role.github_action-dev.arn, dev_bucket_arn = aws_s3_bucket.static_web_sre-dev.arn })
  #의존성 추가
  depends_on = [aws_s3_bucket_public_access_block.static_web_sre-dev]
}

# S3 # 'prod'용 정적 웹사이트 Bucket
resource "aws_s3_bucket" "static_web_sre-prod" {
  bucket = var.prod_web_bucket_name
  region = var.region
  tags = {
    Environment = "Production"
    IaCTool     = "Terraform"
  }
}
# S3 객체 소유권 설정
resource "aws_s3_bucket_ownership_controls" "static_web_sre-prod" {
  bucket = aws_s3_bucket.static_web_sre-prod.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Bucket Public Access 접근 허용
resource "aws_s3_bucket_public_access_block" "static_web_sre-prod" {
  bucket = aws_s3_bucket.static_web_sre-prod.id

  # 인터넷을 통한 외부 접근 허용. 단, 내부에 뭐가 있는지는 볼 수 없게하기
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
  depends_on              = [aws_s3_bucket_ownership_controls.static_web_sre-prod]
}

# S3 Bucket에 사용할 웹 서버 페이지 객체 생성
resource "aws_s3_object" "prod-index_page" {
  bucket = aws_s3_bucket.static_web_sre-prod.id
  key    = "index.html"
  # 객체 컨텐츠 설정
  content_base64 = "PCFET0NUWVBFIGh0bWw+DQo8aHRtbD4NCjxoZWFkPg0KPHRpdGxlPlByb2QgUGFnZTwvdGl0bGU+DQo8L2hlYWQ+DQo8Ym9keT4NCg0KPGgxPlByb2R1Y3Rpb24gUGFnZTwvaDE+DQoNCjwvYm9keT4NCjwvaHRtbD4="
  content_type   = "text/html"
  # 접근 권한 설정

  depends_on = [aws_s3_bucket_ownership_controls.static_web_sre-prod, aws_s3_bucket_public_access_block.static_web_sre-prod]
}

# Bucket Website 구성
resource "aws_s3_bucket_website_configuration" "prod" {
  bucket = aws_s3_bucket.static_web_sre-prod.id
  # 지정된 기본 페이지 위치
  index_document {
    suffix = "index.html"
  }
  #에러 페이지
  error_document {
    key = "error.html"
  }
}

# Bucket Policy 설정
resource "aws_s3_bucket_policy" "prod" {
  bucket = aws_s3_bucket.static_web_sre-prod.id
  policy = templatefile("./iam/policy_docs/bootstrap/prod_bucket.json", { prod_role_arn = aws_iam_role.github_action-prod.arn, prod_bucket_arn = aws_s3_bucket.static_web_sre-prod.arn })
  #의존성 추가
  depends_on = [aws_s3_bucket_public_access_block.static_web_sre-prod]
}

# CloudFront # SSL/TLS 용도