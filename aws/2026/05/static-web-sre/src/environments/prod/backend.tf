terraform {
  backend "s3" {
    bucket = "lee-static-web-sre-state-storage"
    key    = "prod/state.tfstate"
    region = "ap-northeast-2"
  }
}