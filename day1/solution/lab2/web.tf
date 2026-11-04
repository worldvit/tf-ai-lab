# 실습 ③ 정답: 퍼블릭 서브넷의 EC2 웹 서버
# AMI는 하드코딩하지 않고 AWS가 관리하는 SSM 파라미터에서 최신 Amazon Linux 2023을 읽는다
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "web" {
  name        = "tfai-web-sg"
  description = "HTTP from anywhere"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.web.id]
  user_data_replace_on_change = true
  user_data                   = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    echo "<h1>Hello from Terraform + AI</h1><p>$(hostname -f)</p>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOT
  metadata_options {
    http_tokens = "required"
  }
  tags = { Name = "tfai-web" }
}

output "web_url" {
  value = "http://${aws_instance.web.public_ip}"
}
