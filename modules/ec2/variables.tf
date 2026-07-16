variable "subnet_id" {
  description = "Public subnet ID to launch the instance into"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID to attach to the instance"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name to attach to the instance"
  type        = string
}

variable "key_name" {
  description = "Name of an existing EC2 key pair, used for SSH access"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name, used in tags"
  type        = string
  default     = "dev"
}
variable "project" {
  description = "Project name"
  type        = string
  default     = "reconcile"
}