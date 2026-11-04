# 실습 ① 정답: Day 1 VPC를 변수·for_each로 리팩터링
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "${var.name}-vpc" }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.name}-igw" }
}

resource "aws_subnet" "public" {
  for_each                = local.public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.name}-public-${each.key}" }
}

resource "aws_subnet" "private" {
  for_each          = local.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags              = { Name = "${var.name}-private-${each.key}" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "${var.name}-public-rt" }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# count 번호 → for_each 키로 주소가 바뀐 것을 Terraform에 알려 준다 (없으면 삭제 후 재생성 계획)
moved {
  from = aws_subnet.public[0]
  to   = aws_subnet.public["1"]
}
moved {
  from = aws_subnet.public[1]
  to   = aws_subnet.public["2"]
}
moved {
  from = aws_subnet.private[0]
  to   = aws_subnet.private["1"]
}
moved {
  from = aws_subnet.private[1]
  to   = aws_subnet.private["2"]
}
moved {
  from = aws_route_table_association.public[0]
  to   = aws_route_table_association.public["1"]
}
moved {
  from = aws_route_table_association.public[1]
  to   = aws_route_table_association.public["2"]
}
