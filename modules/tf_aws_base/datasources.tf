data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_version}-v*"]
  }
}

data "aws_route53_zone" "public" {
  name = "interview.zcentric.com."
}
