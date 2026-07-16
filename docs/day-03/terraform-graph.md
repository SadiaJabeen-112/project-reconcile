# Terraform Dependency Graph, Day 03

Generated with terraform graph. Raw output is in terraform-graph.dot.

## What it shows

The EC2 instance depends on four resources directly: the AMI data source, the IAM instance profile, the security group, and the public subnet.

The IAM instance profile depends on the IAM role, which depends on the assume role policy document. That is the full identity chain from policy to compute.

The security group and the subnet both depend on the VPC, which is the root of the networking layer.

The S3 state bucket and its versioning, encryption, and public access block settings form a separate dependency chain, unrelated to the compute and identity resources.

No circular dependencies exist. Every resource depends only on resources created earlier in the chain.