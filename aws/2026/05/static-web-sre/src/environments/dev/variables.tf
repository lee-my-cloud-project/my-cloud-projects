variable "region" {
  type        = string
  description = "AWS의 Region Code"
}

# S3 #
# Bucket : To Trigger Github Action
variable "s3_name" {
  type        = string
  description = "AWS S3의 이름"
}