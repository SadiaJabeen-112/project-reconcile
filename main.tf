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

module "iam" {
  source = "./modules/iam"

  environment = var.environment
  project     = "reconcile"
}

module "security_group" {
  source = "./modules/security_group"

  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  environment      = var.environment
  project          = "reconcile"
}
module "ec2" {
  source = "./modules/ec2"

  subnet_id              = module.vpc.public_subnet_id
  security_group_id      = module.security_group.security_group_id
  instance_profile_name  = module.iam.instance_profile_name
  key_name               = "reconcile-key"
  instance_type          = var.instance_type
  environment            = var.environment
  project                = "reconcile"
}