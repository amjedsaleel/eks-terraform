variable "vpc_cidr_block" {
  type        = string
  description = "eks vpc cidr block"
}

variable "private_subnets_cidr_blocks" {
  type        = list(any)
  description = "eks vpc private subnet cidr blocks"
}

variable "public_subnets_cidr_blocks" {
  type        = list(any)
  description = "eks vpc sublic subnet cidr blocks"
}


# EKS related variables

variable "eks_cluster" {
  type        = string
  description = "eks cluster name"
}

variable "eks_cluster_version" {
  type        = string
  description = "eks cluster name"
}

variable "aws_auth_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  description = "aws auth users"
}

variable "aws_auth_accounts" {
  type        = list(any)
  description = "description"
}
