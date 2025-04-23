terraform {
  cloud {
    organization = "Lee-personal-project"

    workspaces {
      name = "simple-web"
    }
  }
  # Set provider AWS. Version 5.95.0
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.95.0"
    }
  }
}