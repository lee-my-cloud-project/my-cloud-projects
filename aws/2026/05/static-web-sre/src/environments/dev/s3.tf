# Github Action을 동작 시키기 위해 추가한 주석
resource "aws_s3_object" "web-main_page" {
  bucket = var.s3_name
  key    = "index.html"
  source = "web/index.html"
  content_type = "text/html"
}