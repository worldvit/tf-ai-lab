data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "web" {
  name        = "${var.name}-web-sg"
  description = "HTTP from anywhere"
  vpc_id      = var.vpc_id
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
  for_each                    = var.subnet_ids
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = each.value
  vpc_security_group_ids      = [aws_security_group.web.id]
  user_data_replace_on_change = true
  user_data                   = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    echo "<h1>${var.name} web</h1><p>${each.key}</p>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOT
  metadata_options {
    http_tokens = "required"
  }
  tags = { Name = "${var.name}-web-${each.key}" }
}
