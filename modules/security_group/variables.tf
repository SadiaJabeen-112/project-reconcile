variable "vpc_id" {
  description = "VPC ID the security group belongs to"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance (your IP, /32)"
  type        = string
}

variable "environment" {
  description = "Environment name, used in tags"
  type        = string
  default     = "dev"
}