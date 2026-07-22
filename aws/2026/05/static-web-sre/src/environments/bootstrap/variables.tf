variable "aws_id" {
  type        = number
  description = "AWS ID"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "ap-northeast-2"
}

# S3
variable "bucket_name" {
  type        = string
  description = "Project에 사용할 Bucket 이름"

  validation {
    # 1. 3자 이상 63자 이하
    # 2. 소문자, 숫자, 점(.), 하이픈(-)만 허용
    # 3. 시작과 끝은 소문자 또는 숫자여야 함
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "S3 버킷 이름은 3~63자의 소문자, 숫자, 점(.), 하이픈(-)만 사용할 수 있으며, 소문자나 숫자로 시작하고 끝나야 합니다."
  }

  validation {
    # 연속된 점(..)은 허용되지 않음
    condition     = !can(regex("\\.\\.", var.bucket_name))
    error_message = "S3 버킷 이름에 연속된 점(..)을 포함할 수 없습니다."
  }

  validation {
    # IP 주소 형식(예: 192.168.5.4)은 허용되지 않음
    condition     = !can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.bucket_name))
    error_message = "S3 버킷 이름은 IP 주소 형식과 같을 수 없습니다."
  }

  validation {
    # 특정 접두사로 시작 금지
    condition     = !startswith(var.bucket_name, "xn--") && !startswith(var.bucket_name, "sthree-") && !startswith(var.bucket_name, "amzn-s3-demo-")
    error_message = "특정 접두사 'xn--', 'sthree-', 'amzn-s3-demo-'로 시작하면 안됩니다."
  }

  validation {
    # 특정 접두사로 끝 금지
    condition     = !endswith(var.bucket_name, "-s3alias") && !endswith(var.bucket_name, "--ol-s3") && !endswith(var.bucket_name, ".mrap") && !endswith(var.bucket_name, "--x-s3") && !endswith(var.bucket_name, "--table-s3")
    error_message = "특정 접두사 '-s3alias', '--ol-s3', '.mrap', '--x-s3', '--table-s3'로 끝나면 안됩니다."
  }
}
# 'dev'용 Bucket의 이름
variable "dev_web_bucket_name" {
  type        = string
  description = "Project에 사용할 Bucket 이름"

  validation {
    # 1. 3자 이상 63자 이하
    # 2. 소문자, 숫자, 점(.), 하이픈(-)만 허용
    # 3. 시작과 끝은 소문자 또는 숫자여야 함
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.dev_web_bucket_name))
    error_message = "S3 버킷 이름은 3~63자의 소문자, 숫자, 점(.), 하이픈(-)만 사용할 수 있으며, 소문자나 숫자로 시작하고 끝나야 합니다."
  }

  validation {
    # 연속된 점(..)은 허용되지 않음
    condition     = !can(regex("\\.\\.", var.dev_web_bucket_name))
    error_message = "S3 버킷 이름에 연속된 점(..)을 포함할 수 없습니다."
  }

  validation {
    # IP 주소 형식(예: 192.168.5.4)은 허용되지 않음
    condition     = !can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.dev_web_bucket_name))
    error_message = "S3 버킷 이름은 IP 주소 형식과 같을 수 없습니다."
  }

  validation {
    # 특정 접두사로 시작 금지
    condition     = !startswith(var.dev_web_bucket_name, "xn--") && !startswith(var.dev_web_bucket_name, "sthree-") && !startswith(var.dev_web_bucket_name, "amzn-s3-demo-")
    error_message = "특정 접두사 'xn--', 'sthree-', 'amzn-s3-demo-'로 시작하면 안됩니다."
  }

  validation {
    # 특정 접두사로 끝 금지
    condition     = !endswith(var.dev_web_bucket_name, "-s3alias") && !endswith(var.dev_web_bucket_name, "--ol-s3") && !endswith(var.dev_web_bucket_name, ".mrap") && !endswith(var.dev_web_bucket_name, "--x-s3") && !endswith(var.dev_web_bucket_name, "--table-s3")
    error_message = "특정 접두사 '-s3alias', '--ol-s3', '.mrap', '--x-s3', '--table-s3'로 끝나면 안됩니다."
  }
}
# 'prod'용 Bucket의 이름
variable "prod_web_bucket_name" {
  type        = string
  description = "Project에 사용할 Bucket 이름"

  validation {
    # 1. 3자 이상 63자 이하
    # 2. 소문자, 숫자, 점(.), 하이픈(-)만 허용
    # 3. 시작과 끝은 소문자 또는 숫자여야 함
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.prod_web_bucket_name))
    error_message = "S3 버킷 이름은 3~63자의 소문자, 숫자, 점(.), 하이픈(-)만 사용할 수 있으며, 소문자나 숫자로 시작하고 끝나야 합니다."
  }

  validation {
    # 연속된 점(..)은 허용되지 않음
    condition     = !can(regex("\\.\\.", var.prod_web_bucket_name))
    error_message = "S3 버킷 이름에 연속된 점(..)을 포함할 수 없습니다."
  }

  validation {
    # IP 주소 형식(예: 192.168.5.4)은 허용되지 않음
    condition     = !can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.prod_web_bucket_name))
    error_message = "S3 버킷 이름은 IP 주소 형식과 같을 수 없습니다."
  }

  validation {
    # 특정 접두사로 시작 금지
    condition     = !startswith(var.prod_web_bucket_name, "xn--") && !startswith(var.prod_web_bucket_name, "sthree-") && !startswith(var.prod_web_bucket_name, "amzn-s3-demo-")
    error_message = "특정 접두사 'xn--', 'sthree-', 'amzn-s3-demo-'로 시작하면 안됩니다."
  }

  validation {
    # 특정 접두사로 끝 금지
    condition     = !endswith(var.prod_web_bucket_name, "-s3alias") && !endswith(var.prod_web_bucket_name, "--ol-s3") && !endswith(var.prod_web_bucket_name, ".mrap") && !endswith(var.prod_web_bucket_name, "--x-s3") && !endswith(var.prod_web_bucket_name, "--table-s3")
    error_message = "특정 접두사 '-s3alias', '--ol-s3', '.mrap', '--x-s3', '--table-s3'로 끝나면 안됩니다."
  }
}

### Resource Tag
variable "env_bootstrap" {
  type        = map(string)
  description = "Bootstrap 환경에서 생성된 태그"
  default = {
    "Environment" = "Bootstrap"
    "IaCTool"     = "Terraform"
  }
}

# IAM
variable "iam_name-dev" {
  type        = string
  description = "IAM 리소스 이름 (알파벳, 숫자, +, =, ,, ., @, _, - 허용)"

  validation {
    # 영문, 숫자 및 지정된 특수문자(+=,.@_-)만 허용 (공백 불가)
    condition     = can(regex("^[a-zA-Z0-9+=,.@_\\-]+$", var.iam_name-dev))
    error_message = "IAM 이름은 영문, 숫자 및 다음 특수문자만 포함할 수 있습니다: +, =, ,, ., @, _, -"
  }
}

variable "iam_name-prod" {
  type        = string
  description = "IAM 리소스 이름 (알파벳, 숫자, +, =, ,, ., @, _, - 허용)"

  validation {
    # 영문, 숫자 및 지정된 특수문자(+=,.@_-)만 허용 (공백 불가)
    condition     = can(regex("^[a-zA-Z0-9+=,.@_\\-]+$", var.iam_name-prod))
    error_message = "IAM 이름은 영문, 숫자 및 다음 특수문자만 포함할 수 있습니다: +, =, ,, ., @, _, -"
  }
}

variable "iam_name-infra" {
  type        = string
  description = "IAM 리소스 이름 (알파벳, 숫자, +, =, ,, ., @, _, - 허용)"

  validation {
    # 영문, 숫자 및 지정된 특수문자(+=,.@_-)만 허용 (공백 불가)
    condition     = can(regex("^[a-zA-Z0-9+=,.@_\\-]+$", var.iam_name-infra))
    error_message = "IAM 이름은 영문, 숫자 및 다음 특수문자만 포함할 수 있습니다: +, =, ,, ., @, _, -"
  }
}

# Github Action
variable "client_id_list" {
  type        = list(string)
  description = "Open ID Client ID 값 List"
  default     = ["sts.amazonaws.com"]
}

variable "thumbprint_list" {
  type        = list(string)
  description = "Github Action에 사용할 Open ID 값 List"
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

variable "git_org" {
  type        = string
  description = "Github Organization"
}

variable "git_repo" {
  type        = string
  description = "Git 저장소 이름"
}