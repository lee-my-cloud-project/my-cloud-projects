resource "aws_s3_object" "web-main_page" {
  bucket = var.s3_name
  key    = "index.html"
  source = "web/index.html"
  content_type = "text/html"
}