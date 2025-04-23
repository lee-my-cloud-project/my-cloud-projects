# Create AWS ECR Private Registry
resource "aws_ecr_repository" "simple-web" {
  name = "simple-web"

}