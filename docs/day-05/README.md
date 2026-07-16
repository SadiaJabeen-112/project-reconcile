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

## Why this matters for PROJECT RECONCILE

A project meant to detect and reconcile drift needs its own foundation to be dependable and consistent. Inconsistent module design, where some modules are reusable and others are not, is its own quiet form of technical debt. Fixing it now, while the project is still small, is far cheaper than fixing it after six more days of code are built on top of the inconsistency.

## Next

Day 06 introduces automated drift detection through scheduled Terraform plan runs.

[Back to PROJECT RECONCILE](../../README.md)