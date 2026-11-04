variable "name" {
  description = "리소스 이름 접두사"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR (/16 권장)"
  type        = string
}

variable "az_count" {
  description = "사용할 AZ 수"
  type        = number
  default     = 2
  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count는 2 또는 3이어야 한다."
  }
}
