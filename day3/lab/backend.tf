# 상태는 S3. 버킷 이름은 init 때: terraform init -backend-config="bucket=$B"
terraform {
  backend "s3" {
    key          = "day3/lab.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
