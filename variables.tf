variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "allowed_ssh_cidr" {
  description = "Your public IP, restricted to /32, allowed to SSH into the EC2 instance"
  type        = string
  default     = "49.206.192.30/32"
}
variable "instance_type" {
  description = "EC2 instance type for the RECONCILE instance"
  type        = string
  default     = "t2.micro"
}