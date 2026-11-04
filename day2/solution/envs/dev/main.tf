# 실습 ③ 정답: 모듈 두 개를 이어 붙인 dev 환경
module "network" {
  source   = "../../modules/network"
  name     = "tfai-dev"
  vpc_cidr = "10.50.0.0/16"
  az_count = 2
}

module "compute" {
  source        = "../../modules/compute"
  name          = "tfai-dev"
  vpc_id        = module.network.vpc_id
  subnet_ids    = module.network.public_subnet_ids
  instance_type = "t3.micro"
}

output "web_urls" {
  value = module.compute.web_urls
}
