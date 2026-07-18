package terraform.reconcile

import future.keywords.in

auto_approved_fields := {"public_ip", "public_dns"}

sensitive_types := {
    "aws_security_group",
    "aws_security_group_rule",
    "aws_iam_role",
    "aws_iam_role_policy",
    "aws_iam_instance_profile",
    "aws_s3_bucket",
    "aws_s3_bucket_versioning",
}

deny contains msg if {
    change := input.resource_changes[_]
    change.change.actions[_] == "update"
    rtype := change.type
    sensitive_types[rtype]
    msg := sprintf("Manual approval required: %s (%s) has a planned change", [change.address, rtype])
}

auto_approved contains msg if {
    change := input.resource_changes[_]
    change.change.actions[_] == "update"
    not sensitive_types[change.type]
    changed_fields := {f | change.change.after[f] != change.change.before[f]; f}
    every f in changed_fields {
        auto_approved_fields[f]
    }
    msg := sprintf("Auto approved: %s, only %v changed", [change.address, changed_fields])
}
