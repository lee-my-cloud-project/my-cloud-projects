variable "region" {
  type        = string
  description = "AWS의 Region Code"
}

# S3 #
# Action을 Trigger하기 위한 주석 1
variable "s3_name" {
  type        = string
  description = "AWS S3의 이름"
}