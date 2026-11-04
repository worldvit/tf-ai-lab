# 실습 ① 정답: 값은 변수로, 계산은 locals로
variable "name" {
  description = "리소스 이름 앞에 붙는 접두사"
  type        = string
  default     = "tfai"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.40.0.0/16"
}

variable "instance_type" {
  description = "웹 서버 인스턴스 유형"
  type        = string
  default     = "t3.micro"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  # count(숫자 번호) 대신 이름표(키)로 관리하면 중간 항목을 지워도 나머지 번호가 밀리지 않는다
  public_subnets = {
    "1" = { az = local.azs[0], cidr = cidrsubnet(var.vpc_cidr, 8, 0) }
    "2" = { az = local.azs[1], cidr = cidrsubnet(var.vpc_cidr, 8, 1) }
  }
  private_subnets = {
    "1" = { az = local.azs[0], cidr = cidrsubnet(var.vpc_cidr, 8, 10) }
    "2" = { az = local.azs[1], cidr = cidrsubnet(var.vpc_cidr, 8, 11) }
  }
}
