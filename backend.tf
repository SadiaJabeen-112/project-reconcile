terraform {
  backend "s3" {
    bucket       = "reconcile-tfstate-dev-2026"
    key          = "project-reconcile/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}