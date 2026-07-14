# PROJECT RECONCILE

### Terraform Drift Detection and Controlled Remediation on AWS

PROJECT RECONCILE is an infrastructure drift detection and controlled remediation platform built with Terraform and AWS.

Terraform defines what infrastructure should look like.

AWS runs what actually exists.

The problem begins when those two views stop matching.

A Security Group rule may be changed manually. A route may be updated during troubleshooting. An EC2 configuration may be modified directly in AWS.

The infrastructure may continue running, but the environment no longer matches the Terraform configuration stored in source control.

PROJECT RECONCILE is being built around that problem.

> Detect → Preserve Evidence → Evaluate → Remediate → Verify

The goal is not to run terraform apply every time a difference appears.

The goal is to understand the change, retain evidence, evaluate the risk and restore infrastructure through a controlled workflow.

## Architecture

![PROJECT RECONCILE Architecture](docs/images/project-reconcile-architecture.png)

The diagram represents the target architecture for PROJECT RECONCILE.

The AWS infrastructure baseline is already deployed. Drift detection, evidence capture, policy evaluation and controlled remediation are being added progressively as the project develops.

## The Problem

Infrastructure changes outside Terraform more often than most teams would like to admit.

• Emergency production fixes

• Manual AWS Console changes

• Security Group updates

• Route modifications

• Resource configuration changes

• Temporary troubleshooting changes that are never reverted

Terraform may eventually detect the difference.

Detection alone does not answer the operational questions.

What changed?

Was the change intentional?

Does it introduce risk?

Should Terraform restore the original configuration?

Should the code be updated because the change was legitimate?

What evidence existed before remediation?

PROJECT RECONCILE treats drift detection as the beginning of the process, not the final step.

## Reconciliation Workflow

| Stage | Responsibility |
| :--- | :--- |
| 🔎 Detect | Compare Terraform configuration with infrastructure observed in AWS |
| 📁 Preserve Evidence | Capture Terraform plan output before infrastructure is changed |
| 🛡️ Evaluate | Assess the detected change against policy and approval controls |
| 🔄 Remediate | Reconcile approved changes through Terraform |
| ✅ Verify | Confirm that infrastructure has returned to the approved state |

## Current AWS Baseline

The first Terraform managed AWS environment is now live.

| AWS Component | Current Implementation |
| :--- | :--- |
| VPC | 10.0.0.0/16 |
| DNS | DNS support and DNS hostnames enabled |
| Public Subnet | us-east-1a |
| Public IP Mapping | Enabled |
| Internet Gateway | Attached to the project VPC |
| Route Table | Default route through the Internet Gateway |
| Security Group | SSH restricted to the operator IP |
| IAM | EC2 role and instance profile |
| Systems Manager | AmazonSSMManagedInstanceCore attached |
| EC2 | Amazon Linux 2023 |
| Root Volume | 30 GB |
| S3 | Versioning and AES256 encryption enabled |
| Terraform State | 12 resources currently tracked |

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
    │
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    │
    ├── modules/
    │   ├── vpc/
    │   ├── s3/
    │   ├── security_group/
    │   ├── iam/
    │   └── ec2/
    │
    ├── opa/
    ├── scripts/
    │
    ├── .github/
    │   └── workflows/
    │
    ├── docs/
    │   ├── images/
    │   ├── day-01/
    │   ├── day-02/
    │   └── day-03/
    │
    └── README.md

The Terraform modules are separated by infrastructure responsibility.

The repository will continue to grow with drift detection scripts, policy definitions and GitHub Actions workflows as the reconciliation pipeline is implemented.

## TerraWeek Build Journey

PROJECT RECONCILE is being built across the seven days of TerraWeek.

Each day's Terraform scope is being applied to the same project instead of being maintained as an isolated lab.

| Day | Focus | PROJECT RECONCILE |
| :---: | :--- | :--- |
| 01 | Terraform and IaC Foundation | Project architecture, repository structure and Terraform foundation |
| 02 | HCL and AWS Infrastructure | VPC, subnet, Internet Gateway, routing and S3 state foundation |
| 03 | Resources and Dependencies | Security Group, IAM role, instance profile and EC2 deployment |
| 04 | Terraform State | Remote state and state locking |
| 05 | Modules and Provider Design | Reusable infrastructure and module refinement |
| 06 | Automation and CI/CD | Scheduled drift detection and Terraform plan evidence |
| 07 | Drift and Remediation | Policy evaluation, approval, controlled remediation and verification |

## Day 01 | Project Foundation

The first day established the direction of the project.

• Defined the PROJECT RECONCILE architecture

• Verified Terraform CLI

• Verified AWS CLI authentication

• Created the repository structure

• Configured the AWS provider

• Added Terraform and provider version constraints

• Parameterized the AWS region and environment

• Protected Terraform state and working files from source control

No AWS resources were deployed.

The objective was to establish a clean Terraform foundation before infrastructure provisioning began.

## Day 02 | AWS Network and State Foundation

The second day introduced the first AWS infrastructure design.

• Built a reusable VPC module

• Defined the 10.0.0.0/16 network

• Created the public subnet layer in us-east-1a

• Attached an Internet Gateway

• Configured the default 0.0.0.0/0 route

• Associated the route table with the public subnet

• Built the S3 state storage module

• Enabled S3 versioning

• Enabled AES256 server side encryption

• Blocked public access to the state bucket

• Exposed infrastructure outputs for downstream modules

Terraform produced the following plan:

> 9 to add, 0 to change, 0 to destroy

The infrastructure was deliberately not applied on Day 02.

The plan was reviewed as infrastructure intent before execution.

## Day 03 | Compute and Access Layer

Day 03 moved PROJECT RECONCILE from planning to real AWS deployment.

• Created the EC2 Security Group

• Restricted SSH to the configured operator IP

• Created the EC2 IAM role

• Created the IAM instance profile

• Attached AmazonSSMManagedInstanceCore

• Added AWS Systems Manager as an alternative management path

• Created the EC2 module

• Deployed Amazon Linux 2023

The first terraform apply failed.

The configured root volume was 8 GB.

The Amazon Linux 2023 AMI snapshot required at least 30 GB.

Terraform successfully generated the plan, but the AWS API rejected the resource during creation.

That failure exposed an important validation boundary.

> A successful Terraform plan does not guarantee that the cloud API will accept every resource value during execution.

The root volume was corrected to 30 GB.

The infrastructure was planned again and successfully applied.

The EC2 instance is now running.

Twelve resources are tracked in Terraform state.

## Day 04 | Terraform State

The next stage focuses on Terraform state as an infrastructure control component.

Planned work includes:

• Move the project to remote Terraform state

• Configure the S3 backend

• Introduce state locking

• Verify state consistency

• Test concurrent execution protection

The state layer is particularly important to PROJECT RECONCILE because drift detection depends on the relationship between Terraform configuration, Terraform state and actual AWS infrastructure.

## Day 05 | Reusable Infrastructure

Day 05 will focus on improving the Terraform design as the project grows.

Planned work includes:

• Review existing module boundaries

• Refine module inputs and outputs

• Remove unnecessary infrastructure coupling

• Improve provider configuration

• Validate module reuse across environments

The objective is to keep the infrastructure reusable without hiding important resource relationships behind unnecessary abstraction.

## Day 06 | Drift Detection Automation

Day 06 moves the project toward its primary purpose.

Planned work includes:

• Introduce scheduled drift detection

• Execute terraform plan through GitHub Actions

• Detect infrastructure differences

• Preserve Terraform plan output

• Store plan evidence as a pipeline artifact

• Prepare detected changes for policy evaluation

This stage begins the automated PROJECT RECONCILE workflow.

## Day 07 | Controlled Remediation

The final TerraWeek stage connects the complete reconciliation flow.

Planned work includes:

• Evaluate detected drift against policy

• Introduce OPA or Conftest policy checks

• Approve or block remediation

• Execute controlled terraform apply

• Verify infrastructure after remediation

• Preserve the reconciliation result

The intended workflow is:

> Out of Band Change → Detect Drift → Preserve Evidence → Evaluate Policy → Approve → Remediate → Verify

## Security Approach

Security controls are being included in the Terraform design from the beginning.

• SSH is restricted to the configured operator IP

• Port 22 is not exposed to 0.0.0.0/0

• AWS Systems Manager provides an alternative management path

• EC2 permissions are assigned through an IAM instance role

• Terraform state storage uses versioning

• Server side encryption uses AES256

• Public access to the state bucket is blocked

• Terraform state files are excluded from source control

## Project Status

| Capability | Status |
| :--- | :---: |
| Project Foundation | ✅ Complete |
| AWS Network Foundation | ✅ Complete |
| State Storage Foundation | ✅ Complete |
| EC2 Compute Layer | ✅ Complete |
| IAM and SSM Integration | ✅ Complete |
| AWS Infrastructure Baseline | ✅ Complete |
| Remote State and Locking | ⏳ Next |
| Drift Detection | 📋 Planned |
| Evidence Preservation | 📋 Planned |
| Policy Evaluation | 📋 Planned |
| Controlled Remediation | 📋 Planned |
| End to End Verification | 📋 Planned |

## What Comes Next

The project now has something it did not have on Day 01.

A real Terraform managed AWS infrastructure baseline.

The next challenge is no longer provisioning infrastructure.

The next challenge is changing that infrastructure outside Terraform and proving that PROJECT RECONCILE can detect what changed, preserve the evidence and decide what happens next.

PROJECT RECONCILE is actively under development as part of TerraWeek.

**Detect → Preserve Evidence → Evaluate → Remediate → Verify**
