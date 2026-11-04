# 파이프라인 연결 확인용 — AWS 리소스를 만들지 않는다
resource "terraform_data" "hello" {
  input = "pipeline ok"
}

output "hello" {
  value = terraform_data.hello.output
}
