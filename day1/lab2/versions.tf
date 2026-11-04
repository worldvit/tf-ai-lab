# 버전과 공통 태그는 미리 정해 둔다. AI에게 코드를 받을 때 이 파일은 그대로 두고 main.tf만 받는다.
terraform {
  required_version = "~> 1.17"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
  default_tags {
    tags = {
      Course = "04"
      Day    = "1"
    }
  }
}
