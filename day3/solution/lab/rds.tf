resource "aws_security_group" "db" {
  name        = "${var.name}-db"
  description = "RDS - MySQL from web servers only"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "db_from_web" {
  security_group_id            = aws_security_group.db.id
  description                  = "MySQL from web servers"
  referenced_security_group_id = aws_security_group.web.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.name}-db"
  subnet_ids = [for s in aws_subnet.private : s.id]
}

resource "aws_db_instance" "main" {
  identifier                 = "${var.name}-db"
  engine                     = "mysql"
  engine_version             = "8.4"
  instance_class             = "db.t4g.micro"
  allocated_storage          = 20
  storage_type               = "gp3"
  storage_encrypted          = true
  db_subnet_group_name       = aws_db_subnet_group.main.name
  vpc_security_group_ids     = [aws_security_group.db.id]
  publicly_accessible        = false
  username                   = "admin"
  password                   = var.db_password
  backup_retention_period    = 1
  copy_tags_to_snapshot      = true
  auto_minor_version_upgrade = true
  # 실습용 — 운영에서는 deletion_protection = true, 최종 스냅샷 남김
  deletion_protection = false
  skip_final_snapshot = true
}
