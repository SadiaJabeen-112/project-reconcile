output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = module.vpc.public_subnet_id
}

output "state_bucket_id" {
  description = "State bucket ID"
  value       = module.s3.bucket_id
}
