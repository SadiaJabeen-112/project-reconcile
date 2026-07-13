variable "bucket_name" {
  description = "S3 bucket name for remote state"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "reconcile"
}
