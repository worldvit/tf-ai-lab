output "web_urls" {
  description = "키 → 웹 서버 주소"
  value       = { for k, i in aws_instance.web : k => "http://${i.public_ip}" }
}
