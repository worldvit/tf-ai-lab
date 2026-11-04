# 원격 상태(state)를 보관할 S3 버킷 — 과정 동안 한 번 만들고 마지막 날 지운다
# 이 폴더의 상태 파일은 작업용 EC2에만 남는다 (버킷을 만들기 전이라 원격에 둘 수 없다)
resource "aws_s3_bucket" "state" {
  bucket_prefix = "tfai-state-"
  force_destroy = true # 실습용: 마지막 날 객체가 남아 있어도 지울 수 있게
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled" # 상태 파일이 망가져도 이전 버전으로 되돌릴 수 있게
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket" {
  value = aws_s3_bucket.state.bucket
}
