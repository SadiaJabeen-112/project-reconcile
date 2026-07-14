# TerraWeek Day 03

## Security, Identity and Compute on AWS

Day 03 moved PROJECT RECONCILE from infrastructure planning to an actual AWS deployment.

The focus was on building the security and compute layer required for the project.

## Infrastructure added

The Terraform configuration was extended with:

* Security Group
* IAM Role
* IAM Instance Profile
* EC2 Instance

The Security Group controls network access to the EC2 instance.

The IAM Role provides AWS permissions to the compute layer without storing static AWS credentials on the instance.

The Instance Profile connects the IAM Role with EC2.

## First Terraform deployment

After reviewing the Terraform plan, the infrastructure was deployed using Terraform apply.

This was the first real infrastructure deployment for PROJECT RECONCILE.

Terraform created the AWS resources from the desired configuration defined in code.

## Why this matters for PROJECT RECONCILE

PROJECT RECONCILE is being built around the difference between desired infrastructure and actual infrastructure.

Terraform defines the desired state.

AWS represents the running infrastructure.

If someone later changes a managed AWS resource outside Terraform, the actual infrastructure may no longer match the configuration.

That difference is infrastructure drift.

The EC2 instance deployed during Day 03 gives the project a real managed resource that can later be intentionally modified to test drift detection.

## Security approach

Access is being designed around controlled permissions.

The EC2 instance uses an IAM Role and Instance Profile instead of embedded AWS credentials.

Network access is controlled through the Security Group.

This keeps the infrastructure foundation suitable for the drift detection and remediation workflow planned for the later stages of PROJECT RECONCILE.

## Day 03 result

PROJECT RECONCILE now has a real AWS compute resource managed through Terraform.

The project has moved from configuration and planning into deployed infrastructure.

## Next

Day 04 introduces Terraform remote state and state locking.

The Terraform state will be moved away from the local workstation and prepared for a safer shared workflow.

[Back to PROJECT RECONCILE](../../README.md)
