output "alb_url" {
  value = "http://${aws_lb.web.dns_name}"
}

output "db_endpoint" {
  value = aws_db_instance.main.address
}
