# CloudWatch가 이메일로 경고를 보내기 위해 설정
resource "aws_sns_topic" "error-budget" {
  provider = aws.virginia
  name     = "static-web-sre-5XX_error_budget"
}

resource "aws_sns_topic_subscription" "via_email" {
  provider = aws.virginia

  topic_arn = aws_sns_topic.error-budget.arn
  protocol  = "email"
  endpoint  = var.email_address
}