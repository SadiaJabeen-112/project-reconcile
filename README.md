# PROJECT RECONCILE

### Terraform Drift Detection and Controlled Remediation on AWS

PROJECT RECONCILE is an infrastructure drift detection and controlled remediation platform built with Terraform and AWS.

Terraform defines what infrastructure should look like.

AWS runs what actually exists.

The problem begins when those two views stop matching.

A Security Group rule may be changed manually. A route may be updated during troubleshooting. An EC2 configuration may be modified directly in AWS.

The infrastructure may continue running, but the environment no longer matches the Terraform configuration stored in source control.

PROJECT RECONCILE was built around that problem.

Detect to Preserve Evidence to Evaluate to Remediate to Verify

The goal was not to run terraform apply every time a difference appears. The goal was to understand the change, retain evidence, evaluate the risk and restore infrastructure through a controlled workflow.

## Architecture

![PROJECT RECONCILE Architecture](docs/images/project-reconcile-architecture.jpeg)

The diagram represents the architecture built for PROJECT RECONCILE across TerraWeek. The AWS infrastructure baseline, drift detection, evidence capture, policy evaluation and controlled remediation are all live and have been verified end to end.

## The Problem

Infrastructure changes outside Terraform more often than most teams would like to admit.

Emergency production fixes. Manual AWS Console changes. Security Group updates. Route modifications. Resource configuration changes. Temporary troubleshooting changes that are never reverted.

Terraform may eventually detect the difference, but detection alone does not answer the real questions. What changed. Was it intentional. Does it introduce risk. Should Terraform restore the original configuration, or should the code be updated because the change was legitimate. What evidence existed before remediation.

PROJECT RECONCILE treats drift detection as the beginning of the process, not the final step.

## Reconciliation Workflow

| Stage | Responsibility |
| :--- | :--- |
| Detect | Compare Terraform configuration with infrastructure observed in AWS |
| Preserve Evidence | Capture Terraform plan output before infrastructure is changed |
| Evaluate | Assess the detected change against policy and approval controls |
| Remediate | Reconcile approved changes through Terraform |
| Verify | Confirm that infrastructure has returned to the approved state |

## Current AWS Baseline

The first Terraform managed AWS environment is live.

| AWS Component | Current Implementation |
| :--- | :--- |
| VPC | 10.0.0.0/16 |
| DNS | DNS support and DNS hostnames enabled |
| Public Subnet | us-east-1a |
| Public IP Mapping | Enabled |
| Internet Gateway | Attached to the project VPC |
| Route Table | Default route through the Internet Gateway |
| Security Group | SSH restricted to the operator IP |
| IAM | EC2 role and instance profile, dedicated least-privilege CI user |
| Systems Manager | AmazonSSMManagedInstanceCore attached |
| EC2 | Amazon Linux 2023 |
| Root Volume | 30 GB |
| S3 | Versioning, AES256 encryption, native state locking |
| Terraform State | Remote, shared, and locked in S3 |

## Infrastructure State Model

PROJECT RECONCILE works with three views of infrastructure.

| View | What it represents |
| :--- | :--- |
| Terraform Configuration | The intended infrastructure |
| Terraform State | Infrastructure currently managed by Terraform |
| AWS Infrastructure | Resources observed through the AWS provider |

Drift becomes visible when the infrastructure running in AWS no longer matches the intended Terraform configuration.

## Repository Structure

    project-reconcile/
    |
    |-- main.tf
    |-- variables.tf
    |-- outputs.tf
    |-- providers.tf
    |
    |-- modules/
    |   |-- vpc/
    |   |-- s3/
    |   |-- security_group/
    |   |-- iam/
    |   \-- ec2/
    |
    |-- opa/
    |   \-- policies/
    |-- scripts/
    |
    |-- .github/
    |   \-- workflows/
    |
    |-- docs/
    |   |-- images/
    |   |-- day-01/
    |   |-- day-02/
    |   |-- day-03/
    |   |-- day-04/
    |   |-- day-05/
    |   |-- day-06/
    |   \-- day-07/
    |
    \-- README.md

The Terraform modules are separated by infrastructure responsibility.

## TerraWeek Build Journey

PROJECT RECONCILE was built across the seven days of TerraWeek. Each day's Terraform scope was applied to the same project instead of being maintained as an isolated lab.

| Day | Focus | PROJECT RECONCILE |
| :---: | :--- | :--- |
| 01 | Terraform and IaC Foundation | Project architecture, repository structure and Terraform foundation |
| 02 | HCL and AWS Infrastructure | VPC, subnet, Internet Gateway, routing and S3 state foundation |
| 03 | Resources and Dependencies | Security Group, IAM role, instance profile and EC2 deployment |
| 04 | Terraform State | Remote state and native S3 state locking |
| 05 | Modules and Provider Design | Reusable infrastructure and module refinement |
| 06 | Automation and CI/CD | Scheduled drift detection and Terraform plan evidence |
| 07 | Drift and Remediation | Policy evaluation, approval, controlled remediation and verification |

## Day 01 | Project Foundation

The first day established the direction of the project.

Defined the PROJECT RECONCILE architecture. Verified Terraform CLI. Verified AWS CLI authentication. Created the repository structure. Configured the AWS provider. Added Terraform and provider version constraints. Parameterized the AWS region and environment. Protected Terraform state and working files from source control.

No AWS resources were deployed. The objective was to establish a clean Terraform foundation before infrastructure provisioning began.

## Day 02 | AWS Network and State Foundation

The second day introduced the first AWS infrastructure design.

Built a reusable VPC module. Defined the 10.0.0.0/16 network. Created the public subnet layer in us-east-1a. Attached an Internet Gateway. Configured the default 0.0.0.0/0 route. Associated the route table with the public subnet. Built the S3 state storage module. Enabled S3 versioning. Enabled AES256 server side encryption. Blocked public access to the state bucket. Exposed infrastructure outputs for downstream modules.

Terraform produced the following plan: 9 to add, 0 to change, 0 to destroy.

The infrastructure was deliberately not applied on Day 02. The plan was reviewed as infrastructure intent before execution.

## Day 03 | Compute and Access Layer

Day 03 moved PROJECT RECONCILE from planning to real AWS deployment.

Created the EC2 Security Group. Restricted SSH to the configured operator IP. Created the EC2 IAM role. Created the IAM instance profile. Attached AmazonSSMManagedInstanceCore. Added AWS Systems Manager as an alternative management path. Created the EC2 module. Deployed Amazon Linux 2023.

The first terraform apply failed. The configured root volume was 8 GB, but the Amazon Linux 2023 AMI snapshot required at least 30 GB. Terraform successfully generated the plan, but the AWS API rejected the resource during creation.

That failure exposed an important lesson. A successful Terraform plan does not guarantee that the cloud API will accept every resource value during execution.

The root volume was corrected to 30 GB. The infrastructure was planned again and successfully applied.

## Day 04 | Terraform State

Day 04 moved the project to remote Terraform state.

Migrated to an S3 backend. Enabled native S3 state locking with use_lockfile = true. Removed the need for a separate DynamoDB lock table. Verified state consistency after migration. Confirmed concurrent execution protection under real CI conditions.

A real bug was found and fixed during this stage. backend.tf had been committed as an empty file, causing Terraform to silently fall back to local state instead of the intended remote backend. Once caught, the backend configuration was restored and the CI pipeline was confirmed to be reading and writing against the correct shared state.

## Day 05 | Reusable Infrastructure

Day 05 focused on improving the Terraform design as the project grew.

Reviewed and tightened module boundaries. Refined module inputs and outputs. Removed unnecessary infrastructure coupling. Improved provider configuration. Validated module reuse across the project.

The objective was to keep the infrastructure reusable without hiding important resource relationships behind unnecessary abstraction.

## Day 06 | Drift Detection Automation

Day 06 moved the project toward its primary purpose.

Introduced scheduled drift detection running every 6 hours via GitHub Actions. Added a manual dispatch trigger for on-demand validation. Created a dedicated least-privilege IAM user, reconcile-ci, for CI execution. Executed terraform plan in CI and compared it against real AWS state. Preserved every plan as an uploaded GitHub Actions artifact for auditability.

Found and fixed a real bug where backend.tf had been committed empty, causing the pipeline to silently compare against local state instead of the shared remote backend.

![Day 06 Root Cause Analysis](docs/day-06/images/root-cause-analysis.jpeg)

Full writeup: docs/day-06/README.md

This stage closed with a validated, repeatable, auditable drift detection pipeline running against the live AWS environment.

## Day 07 | Controlled Remediation

The final TerraWeek stage connected the complete reconciliation flow.

Wrote OPA and Rego policy, evaluated via Conftest, to auto-approve safe drift such as EC2 public IP or DNS changes and require manual approval for sensitive changes such as security groups, IAM or S3.

Split the pipeline into a drift-check job and an approval-gated apply job. Created a production-apply GitHub Environment with a required human reviewer, and confirmed the approval gate genuinely pauses execution rather than passing through silently.

Introduced deliberate test drift, watched the pipeline correctly detect it, evaluate it against policy, and pause for approval. Approved the gate and watched terraform apply execute against the exact approved plan.

Ran a post-apply verification plan, which returned: No changes. Your infrastructure matches the configuration.

Uploaded the post-apply verification output as evidence, closing the audit trail.

The full reconciliation loop was executed and verified end to end: Out of Band Change to Detect Drift to Preserve Evidence to Evaluate Policy to Approve to Remediate to Verify.

## Security Approach

Security controls were included in the Terraform design from the beginning.

SSH is restricted to the configured operator IP. Port 22 is not exposed to 0.0.0.0/0. AWS Systems Manager provides an alternative management path. EC2 permissions are assigned through an IAM instance role. Terraform state storage uses versioning. Server side encryption uses AES256. Public access to the state bucket is blocked. Terraform state files are excluded from source control. CI execution uses a dedicated least-privilege IAM user, scoped to only the permissions the pipeline actually needs.

## Project Status

| Capability | Status |
| :--- | :---: |
| Project Foundation | Complete |
| AWS Network Foundation | Complete |
| State Storage Foundation | Complete |
| EC2 Compute Layer | Complete |
| IAM and SSM Integration | Complete |
| AWS Infrastructure Baseline | Complete |
| Remote State and Locking | Complete |
| Drift Detection | Complete |
| Evidence Preservation | Complete |
| Policy Evaluation | Complete |
| Controlled Remediation | Complete |
| End to End Verification | Complete |

## What Comes Next

PROJECT RECONCILE now has what it did not have on Day 01: a real Terraform managed AWS infrastructure baseline, an automated drift detection pipeline, policy-based evaluation, an approval-gated remediation flow, and a verified end-to-end reconciliation loop.

The full cycle has been proven in a live, attended run. Drift was introduced, detected, evaluated, approved, remediated, and verified clean.

Future work includes hardening the policy set for a wider range of resource types, extending evidence retention, and exploring automated approval for a broader class of low-risk changes.

PROJECT RECONCILE was built as part of TerraWeek.

Detect to Preserve Evidence to Evaluate to Remediate to Verify
