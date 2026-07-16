# TerraWeek Day 04

## Terraform State Management

Day 04 moved PROJECT RECONCILE from local state to remote state management on AWS S3.

## What state is and why it matters

Terraform state tracks what infrastructure Terraform believes exists, including resource IDs, attributes, and dependencies. Local state lives only on one machine, if that machine is lost, the record of everything deployed goes with it. Remote state solves this by storing the state file in a shared, durable location.

## Remote state options considered

Three common approaches exist. Terraform Cloud, HashiCorp's own hosted solution, handles state, locking, and remote runs. AWS S3, storing the state file in a bucket paired with a locking mechanism. HashiCorp Consul, a distributed key value store, more commonly used for service discovery than pure state storage.

S3 was chosen since PROJECT RECONCILE is already AWS native, and the S3 bucket for state was already provisioned in Day 02 with versioning and encryption enabled.

## What was configured

The Terraform backend was configured in backend.tf to use the existing S3 bucket, with encryption enabled and native S3 state locking through use_lockfile, available in Terraform 1.10 and later. This removed the need for a separate DynamoDB locking table.

Existing local state, tracking 14 real deployed resources, was migrated into the new S3 backend using terraform init, with state successfully copied rather than started fresh.

## A real issue found and fixed

After migrating state, terraform plan unexpectedly showed the EC2 instance being replaced, not just updated. Investigation traced this to the AMI data source, configured with most_recent equals true, resolving to a newer Amazon Linux 2023 build than the one the instance was originally created from. Since the ami attribute forces replacement on an EC2 instance, every plan run would have destroyed and recreated the instance, even with no actual configuration changes.

This was resolved by adding ignore_changes for ami inside the instance lifecycle block, intentionally pinning the running instance to its original AMI rather than silently drifting to whatever is newest.

## Verification

terraform plan after the fix showed no changes. terraform state list confirmed all 15 tracked resources are correctly readable through the new S3 backend.

## Why this matters for PROJECT RECONCILE

State is the single source of truth this entire project is built around detecting drift against. Moving it to a durable, shared, locked backend is a prerequisite for the drift detection and remediation work planned in later stages, a project built to detect infrastructure drift cannot itself rely on fragile, single machine local state.

## Next

Day 05 introduces Terraform modules in more depth.

[Back to PROJECT RECONCILE](../../README.md)