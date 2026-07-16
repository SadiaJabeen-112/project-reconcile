variable "environment" {
  description = "Environment name, used in resource names and tags"
  type        = string
  default     = "dev"
}
variable "project" {
  description = "Project name"
  type        = string
  default     = "reconcile"
}