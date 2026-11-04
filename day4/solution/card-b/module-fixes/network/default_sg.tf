# Checkov CKV2_AWS_12 수정: VPC 기본 보안 그룹의 규칙을 모두 비운다
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id
}
