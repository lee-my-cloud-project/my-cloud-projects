terraform {
  backend "s3" {
    bucket = "lee-static-web-sre-state-storage"
    key = "infra/state.tfstate"
    region = "ap-northeast-2"
  }
}