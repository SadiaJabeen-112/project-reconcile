\# PROJECT RECONCILE



A Terraform Drift Detection and Controlled Remediation Platform on AWS, built as part of the TrainWithShubham TerraWeek Challenge (July 12-17, 2026).



\## The idea



What happens when the infrastructure Terraform deployed no longer matches the infrastructure Terraform expects?



RECONCILE is being built to detect infrastructure drift, preserve the change evidence, evaluate it against policy, and route it through a controlled remediation workflow, rather than silently auto-correcting or silently ignoring it.



\## Progress by day



| Day | Focus | Status | Notes |

|---|---|---|---|

| 1 | Foundation: architecture decision, repo setup, tool verification | Done | No resources deployed, groundwork only |

| 2 | VPC, public subnet, Internet Gateway, route table, S3 remote state bucket | Done | terraform plan clean, no apply yet |

| 3 | Security Group, IAM Role + Instance Profile, EC2 instance, first real terraform apply | Done | See docs/day-03.md |

| 4 | Remote state and locking | Planned | |



\## Architecture (as of Day 3)



\- VPC: 10.0.0.0/16, DNS hostnames/support enabled

\- Public subnet: us-east-1a, public IP mapping enabled

\- Internet Gateway attached to the VPC, route table with 0.0.0.0/0 to IGW

\- S3 bucket: versioned, AES256 encrypted, public access fully blocked (becomes the remote state store)

\- Security Group: SSH restricted to a single /32 IP, all outbound allowed

\- IAM Role + Instance Profile: assumed by EC2, with AmazonSSMManagedInstanceCore attached as a fallback access path

\- EC2 instance: latest Amazon Linux 2023 AMI (looked up dynamically, not hardcoded), encrypted gp3 root volume



\## Repo structure

project-reconcile/

├── main.tf

├── variables.tf

├── outputs.tf

├── modules/

│   ├── vpc/

│   ├── s3/

│   ├── security\_group/

│   ├── iam/

│   └── ec2/

└── docs/

└── day-03.md



\## Tech stack



Terraform, AWS (VPC, S3, EC2, IAM, Security Groups), GitHub for version control.



\## Author



Sadia Jabeen, Cloud \& DevOps Engineer

GitHub: github.com/SadiaJabeen-112



Part of the TrainWithShubham TerraWeek Challenge, #TerraWeek #TrainWithShubham  #TWS



