module "vpc" {
  source = "../../modules/vpc"

  environment     = var.environment
  cluster_name    = var.cluster_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "eks" {
  source = "../../modules/eks"

  cluster_name        = var.cluster_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets
  cluster_version     = var.cluster_version
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_desired_size   = var.node_desired_size
  node_instance_types = var.node_instance_types
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}
