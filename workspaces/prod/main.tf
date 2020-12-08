terraform {

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.18.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "default"
}

locals {
  name = "mzupan-interview"
  cidr = "10.244.0.0/16"
}

module "base" {
  source = "../../modules/tf_aws_base"

  vpc_cidr_block = local.cidr
  name           = local.name
}
