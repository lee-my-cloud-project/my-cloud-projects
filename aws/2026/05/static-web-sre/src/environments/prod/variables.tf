variable "region" {
  type        = string
  description = "AWS의 Region Code"
}

# S3 #
# Action 시동용. 사용 후 이 주석을 제거.
variable "s3_name" {
  type        = string
  description = "AWS S3의 이름"
}