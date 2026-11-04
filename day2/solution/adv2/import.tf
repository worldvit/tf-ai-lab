# 심화 2 정답 — 콘솔에서 만든 보안 그룹을 코드 관리로 가져오기
# 1) 콘솔에서 만든 보안 그룹 ID를 아래 id에 넣는다 (sg-로 시작)
# 2) terraform plan -generate-config-out=generated.tf  → 코드 초안 생성
# 3) generated.tf를 읽고 다듬은 뒤 terraform apply      → Plan: 1 to import
import {
  to = aws_security_group.console_made
  id = var.sg_id
}

variable "sg_id" {
  type        = string
  description = "콘솔에서 만든 보안 그룹 ID"
}
