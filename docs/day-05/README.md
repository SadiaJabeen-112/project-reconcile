# TerraWeek Day 05

## Modules and Provider Design

Day 05 focused on reviewing module boundaries across PROJECT RECONCILE, rather than adding new infrastructure.

## The problem found

The vpc and s3 modules already accepted a project variable, making them reusable for a differently named project without editing code inside the module. The iam, security_group, and ec2 modules did not. They had the string reconcile hardcoded directly into resource names and tags.

This meant three of the five modules could not actually be reused as is. Anyone wanting to reuse them for a different project would need to edit code inside the module itself, which defeats the purpose of a module.

## What was changed

A project variable, defaulting to reconcile, was added to the iam, security_group, and ec2 modules, matching the pattern already used in vpc and s3.

Hardcoded reconcile and RECONCILE strings inside each module were replaced with var.project and upper(var.project).

The root main.tf was updated to explicitly pass project into every module call, rather than relying on defaults alone.

## Verification

terraform plan after the change showed no changes. This confirms the refactor was purely structural. Resource names, tags, and behavior are identical, but the module boundary is now consistent across all five modules instead of two.

## Module composition and versioning

The root main.tf composes all five modules together, vpc, s3, iam, security_group, and ec2, each with clear inputs and outputs passed between them.

Versioning was not implemented this stage. All modules are currently referenced by local path, for example source equals ./modules/vpc, which has no concept of a version, it always reflects whatever code currently exists in that folder.

Registry modules, or modules sourced from a separate Git repository, can be pinned to a specific version, so consumers of the module are protected from unexpected changes when the module source is updated. That becomes valuable once a module is shared across multiple projects or teams.

For PROJECT RECONCILE at its current single project stage, local path sourcing is the appropriate choice. Versioning would be revisited if these modules were ever extracted into a separate, shared repository.

## Provider configuration and authentication

The AWS provider has been explicitly configured since Day 01, pinned to version 5.x in providers.tf, with the region parameterized through a variable rather than hardcoded.

Authentication is not hardcoded anywhere in the Terraform configuration. Locally, Terraform resolves AWS credentials through the standard provider credential chain, in this case an AWS CLI profile configured on the local machine. No access keys exist anywhere in the codebase.

This project is intentionally single provider, AWS only. Azure or Google Cloud providers were not introduced, since PROJECT RECONCILE is scoped around AWS infrastructure specifically, not multi cloud provider comparison.

Authentication in an automated context, such as a CI/CD pipeline, cannot rely on a local CLI profile. That distinction becomes relevant in Day 06, where GitHub Actions authenticates using credentials injected as encrypted repository secrets, a separate authentication path from the local one, using the same provider configuration.

## Why this matters for PROJECT RECONCILE

A project meant to detect and reconcile drift needs its own foundation to be dependable and consistent. Inconsistent module design, where some modules are reusable and others are not, is its own quiet form of technical debt. Fixing it now, while the project is still small, is far cheaper than fixing it after six more days of code are built on top of the inconsistency.

## Next

Day 06 introduces automated drift detection through scheduled Terraform plan runs.

[Back to PROJECT RECONCILE](../../README.md)