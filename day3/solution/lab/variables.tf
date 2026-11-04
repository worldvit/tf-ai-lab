variable "name" {
  description = "리소스 이름 접두사"
  type        = string
  default     = "tfai-d3"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.70.0.0/16"
}

variable "instance_type" {
  description = "웹 서버 인스턴스 유형"
  type        = string
  default     = "t3.micro"
}

variable "db_password" {
  description = "RDS 관리자 비밀번호 (export TF_VAR_db_password=... 로 전달)"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_password) >= 12
    error_message = "db_password는 12자 이상"
  }
}
