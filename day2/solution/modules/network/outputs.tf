output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "AZ 이름 → 퍼블릭 서브넷 ID"
  value       = { for az, s in aws_subnet.public : az => s.id }
}

output "private_subnet_ids" {
  description = "AZ 이름 → 프라이빗 서브넷 ID"
  value       = { for az, s in aws_subnet.private : az => s.id }
}
