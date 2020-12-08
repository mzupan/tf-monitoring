module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "v13.2.1"
  cluster_name                    = var.name
  subnets                         = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id
  write_kubeconfig                = "false"
  cluster_version                 = var.eks_version
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true
  enable_irsa                     = true

  worker_groups = [
    {
      name   = "worker"
      ami_id = data.aws_ami.ami.image_id
      override_instance_types = [
        "m5.12xlarge", "c5.12xlarge", "m5.16xlarge"
      ]
      spot_instance_pools       = 20
      spot_allocation_strategy  = "lowest-price"
      asg_max_size              = 2
      asg_desired_capacity      = 2
      kubelet_extra_args        = "--node-labels=node.kubernetes.io/lifecycle=spot"
      public_ip                 = false
      on_demand_base_capacity   = 0
      root_volume_size          = 25
      health_check_grace_period = 15

      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${var.name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        }
      ]
    },
  ]
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
  load_config_file       = false
}

