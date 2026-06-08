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
  assume_role_policy = templatefile("./iam/role/dev/trust_github_action.json", { oidc_providers = aws_iam_openid_connect_provider.github.arn, git_repo = var.git_repo })

  tags = var.env_bootstrap
}
# IAM 정책 문서 생성 "github_action-dev"
resource "aws_iam_policy" "github_action-dev" {
  name        = "github_action-dev"
  description = "Let github action access S3 Bucket"
  policy      = templatefile("./iam/policy_docs/dev/github_action.json", { aws_s3_arn = aws_s3_bucket.static_web_sre-state_storage.arn })

  tags = var.env_bootstrap
}

# IAM # IAM Role 생성. "github_action-prod"
resource "aws_iam_role" "github_action-prod" {
  name               = var.iam_name-prod
  assume_role_policy = templatefile("./iam/role/prod/trust_github_action.json", { oidc_providers = aws_iam_openid_connect_provider.github.arn, git_repo = var.git_repo })
}
# IAM 정책 문서 생성 "github_action-prod"
resource "aws_iam_policy" "github_action-prod" {
  name        = "github_action-prod"
  description = "Let github action access S3 Bucket"
  policy      = templatefile("./iam/policy_docs/prod/github_action.json", { aws_s3_arn = aws_s3_bucket.static_web_sre-state_storage.arn })

  tags = var.env_bootstrap
}