# AI 검증 훈련 ④ 용 "위험 변경" — 디버깅한다며 AI가 제안한 임시 보안 그룹
# live/ 에 debug.tf 로 복사해 PR을 올리면 파이프라인 검사가 막아야 한다
resource "aws_security_group" "debug" {
  name        = "tfai-debug"
  description = "temporary debug access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
