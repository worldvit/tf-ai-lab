# 심화 1 정답 — 공개 모듈(terraform-aws-modules/vpc)로 같은 2AZ 네트워크 만들기
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name            = "tfai-reg"
  cidr            = "10.60.0.0/16"
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = ["10.60.1.0/24", "10.60.2.0/24"]
  private_subnets = ["10.60.11.0/24", "10.60.12.0/24"]

  enable_nat_gateway = false # 시간당 과금 리소스는 끈다
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
