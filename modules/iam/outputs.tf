output "instance_profile_name" {
  description = "Name of the IAM instance profile to attach to the EC2 instance"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = aws_iam_role.ec2_role.arn
}