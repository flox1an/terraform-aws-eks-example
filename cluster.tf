provider "aws" {
  version = ">= 1.47.0"
  region  = "us-east-1"
}

locals {
  cluster_name = "my-cluster"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway = true

   public_subnet_tags         = {
    "kubernetes.io/role/elb" = ""
    "KubernetesCluster"      = "${local.cluster_name}"
  }
  private_subnet_tags                 = {
    "kubernetes.io/role/internal-elb" = ""
    "KubernetesCluster"               = "${local.cluster_name}"
  }
}

module "my-cluster" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = "${local.cluster_name}"
  subnets      = ["${module.vpc.private_subnets}"]
  vpc_id       = "${module.vpc.vpc_id}"

  worker_groups = [
    {
      instance_type = "t3.micro"
      asg_max_size  = 4
      asg_desired_capacity = 3
    },
  ]

  tags = {
    environment = "test"
    "KubernetesCluster"      = "${local.cluster_name}"
  }
}
