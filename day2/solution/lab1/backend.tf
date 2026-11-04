# 실습 ② 정답: 원격 상태. 버킷 이름은 계정마다 달라 init 때 -backend-config로 넣는다
#   terraform init -migrate-state -backend-config="bucket=$(terraform -chdir=../../bootstrap/state-bucket output -raw bucket)"
terraform {
  backend "s3" {
    key          = "day2/lab1.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true # S3 객체(.tflock)로 잠금. DynamoDB 테이블이 필요 없다
  }
}
