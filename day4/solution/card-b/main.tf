# 요구사항 카드 B 정답: Day 2 모듈을 재사용한 2AZ 웹 서버
module "network" {
  source   = "../day2/modules/network"
  name     = "tfai-live"
  vpc_cidr = "10.80.0.0/16"
  az_count = 2
}

module "compute" {
  source        = "../day2/modules/compute"
  name          = "tfai-live"
  vpc_id        = module.network.vpc_id
  subnet_ids    = module.network.public_subnet_ids
  instance_type = "t3.micro"
}

output "url" {
  value = values(module.compute.web_urls)[0]
}

output "web_urls" {
  value = module.compute.web_urls
}
