data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "reconcile-ec2-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name        = "reconcile-ec2-role-${var.environment}"
    Project     = "RECONCILE"
    Environment = var.environment
  }
}

# Lets you connect via AWS Systems Manager Session Manager instead of
# relying only on SSH, useful fallback if your IP ever changes and locks you out.
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "reconcile-ec2-profile-${var.environment}"
  role = aws_iam_role.ec2_role.name
}