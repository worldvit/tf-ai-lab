# tflint 설정 — AWS 규칙 플러그인 사용 (처음 한 번 tflint --init)
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
  enabled = true
  version = "0.50.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
