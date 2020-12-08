locals {
  subnets         = cidrsubnets(var.vpc_cidr_block, 8, 8, 8, 4, 4, 4)
  subnets_public  = slice(local.subnets, 0, 3)
  subnets_private = slice(local.subnets, 3, 6)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name                 = var.name
  cidr                 = var.vpc_cidr_block
  azs                  = slice(data.aws_availability_zones.available.names, 0, 3)
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  public_subnets       = local.subnets_public
  private_subnets      = local.subnets_private

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"   = "1",
    "kubernetes.io/cluster/${var.name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"            = "1",
    "kubernetes.io/cluster/${var.name}" = "shared"
  }
}
