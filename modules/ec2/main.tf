data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "reconcile_ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.instance_profile_name
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    echo "PROJECT RECONCILE EC2 instance provisioned on $(date)" >> /var/log/reconcile-bootstrap.log
  EOF

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  lifecycle {
  create_before_destroy = true
  ignore_changes        = [ami]
}

 tags = {
    Name        = "${var.project}-ec2-${var.environment}"
    Project     = upper(var.project)
    Environment = var.environment
  }
}