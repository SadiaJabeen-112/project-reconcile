module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
  project     = "reconcile"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "reconcile-tfstate-${var.environment}-2026"
  environment = var.environment
  project     = "reconcile"
}