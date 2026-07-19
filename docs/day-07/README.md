# Day 07 | Controlled Remediation

The final day connected the complete reconciliation loop: not just detecting drift, but deciding what to do about it and proving the fix actually worked.

## What Was Built

Wrote OPA and Rego policy, evaluated via Conftest, to auto-approve safe drift such as EC2 public IP or DNS changes, and require manual approval for sensitive changes such as security groups, IAM, or S3.

Split the pipeline into two jobs: drift-check, which plans and evaluates, and apply, which only runs if drift is detected and only after human approval.

Created a production-apply GitHub Environment with a required reviewer, and confirmed through deployment status history that the approval gate genuinely pauses execution rather than passing through silently.

## The Real Blocker

Every early attempt at apply failed with the same error: Cannot apply incomplete plan. Digging into the actual cause revealed that the AWS provider reads back a wide set of sub-configurations whenever it refreshes an S3 bucket resource, including bucket policy, CORS, website configuration, and more. The CI IAM user had only been granted a narrow list of read permissions, so each fix unblocked the next AccessDenied error in the list rather than solving the underlying gap.

The real fix was replacing the narrow permission list with a scoped wildcard, s3 Get all actions, restricted only to the state bucket. That resolved every remaining read permission gap in one pass instead of patching them one at a time.

A separate, smaller gap surfaced next: applying a user_data change on the EC2 instance requires Terraform to stop and restart it, which needed ec2 StopInstances, StartInstances, and ModifyInstanceAttribute permissions that had not yet been granted.

## The Clean Run

With both permission gaps fixed, a fresh attended run was triggered. Deliberate test drift was introduced, the pipeline correctly detected it, evaluated it against policy, and paused for approval.

The deployment was approved. Terraform apply executed against the exact approved plan.

Apply complete. Resources 0 added, 1 changed, 0 destroyed.

A post-apply verification plan ran immediately afterward:

No changes. Your infrastructure matches the configuration.

The verification output was uploaded as evidence, closing the audit trail for this run.

## Result

The full reconciliation loop was executed and verified end to end, in one attended run, with real evidence generated at every stage:

Out of Band Change to Detect Drift to Preserve Evidence to Evaluate Policy to Approve to Remediate to Verify

This is the milestone PROJECT RECONCILE was built toward from Day 01. Every stage of the promised workflow is now proven, not just designed.
