variable "name" {
  description = "리소스 이름 접두사"
  type        = string
}

variable "vpc_id" {
  description = "웹 서버를 둘 VPC"
  type        = string
}

variable "subnet_ids" {
  description = "키 → 서브넷 ID. 서브넷마다 웹 서버를 1대씩 만든다"
  type        = map(string)
}

variable "instance_type" {
  description = "웹 서버 인스턴스 유형"
  type        = string
  default     = "t3.micro"
}
