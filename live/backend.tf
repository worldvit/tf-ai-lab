# 파이프라인과 내 작업 서버가 같은 장부를 쓴다. 버킷은 init 때 -backend-config로
terraform {
  backend "s3" {
    key          = "live/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
