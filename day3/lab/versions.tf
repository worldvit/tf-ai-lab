# 버전과 공통 태그는 미리 정해 둔다. AI에게는 이 파일을 건드리지 말라고 한다.
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
      Day    = "3"
    }
  }
}
