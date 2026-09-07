output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = aws_cloudfront_distribution.static-website-sre.id
}

output "cloudfront_domain_name" {
  description = "CloudFront 도메인"
  value       = aws_cloudfront_distribution.static-website-sre.domain_name
}