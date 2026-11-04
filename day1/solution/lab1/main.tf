# 실습 ① 정답: S3 버킷 1개 (이름 충돌을 피하려고 bucket_prefix 사용)
resource "aws_s3_bucket" "lab" {
  bucket_prefix = "tfai-d1-"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lab" {
  bucket                  = aws_s3_bucket.lab.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  value = aws_s3_bucket.lab.bucket
}
