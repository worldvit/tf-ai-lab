terraform {
  backend "s3" {
    key          = "day4/oidc.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
