module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name    = var.eks_cluster
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    general = {
      min_size                   = 1
      max_size                   = 2
      desired_size               = 1
      instance_types             = ["t3.micro"]
      capacity_type              = "ON_DEMAND"
      use_custom_launch_template = false
      disk_size                  = 80

      labels = {
        role = "general"
      }

    }
  }

  manage_aws_auth_configmap = true

  aws_auth_users = var.aws_auth_users

  aws_auth_accounts = var.aws_auth_accounts

  tags = {
    Name      = "${var.eks_cluster}"
    Env       = "Prod"
    Terraform = "true"
  }

}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.id]
    command     = "aws"
  }
}

data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}
