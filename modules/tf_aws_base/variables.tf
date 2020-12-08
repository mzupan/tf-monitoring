variable "name" {
  description = "The name of the VPC and environment"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for this VPC"
  type        = string
}

variable "eks_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.18"
}
