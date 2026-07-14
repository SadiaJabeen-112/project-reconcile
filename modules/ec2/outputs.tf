output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.reconcile_ec2.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.reconcile_ec2.public_ip
}