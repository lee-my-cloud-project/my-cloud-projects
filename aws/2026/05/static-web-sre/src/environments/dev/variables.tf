variable "region" {
  type        = string
  description = "AWS의 Region Code"
}

# S3 #
# Github Action Trigger용. 사용후 삭제
variable "s3_name" {
  type        = string
  description = "AWS S3의 이름"
}