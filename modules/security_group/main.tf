resource "aws_security_group" "ec2_sg" {
  name        = "reconcile-ec2-sg-${var.environment}"
  description = "Security group for RECONCILE EC2 instance - SSH restricted to a single IP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "reconcile-ec2-sg-${var.environment}"
    Project     = "RECONCILE"
    Environment = var.environment
  }
}