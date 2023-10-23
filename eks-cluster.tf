module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name    = var.eks_cluster
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    disk_size = 80
  }

  eks_managed_node_groups = {
    general = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"

      labels = {
        role = "general"
      }

    }
  }


  tags = {
    Name      = "${var.eks_cluster}"
    Env       = "Prod"
    Terraform = "true"
  }

}
