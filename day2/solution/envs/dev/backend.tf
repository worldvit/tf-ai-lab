terraform {
  backend "s3" {
    key          = "day2/dev.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
