provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# AWS Caller Identity
data "aws_caller_identity" "current" {}

# AWS Availability Zones
data "aws_availability_zones" "available" {}

#
data "aws_partition" "current" {}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

# Retrieve EKS cluster auth configuration
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

locals {
    cluster_name = "${var.cluster_base_name}-${random_string.suffix.result}"
    ebs_csi_role_name = "ebs-csi-role-${random_string.suffix.result}"
    lb_role_name = "lb-role-${random_string.suffix.result}"
    primary_node_group_name = "${var.primary_node_base_group_name}-${random_string.suffix.result}"
    secondary_node_group_name = "${var.secondary_node_base_group_name}-${random_string.suffix.result}"
    
    partition          = data.aws_partition.current.id
    account_id         = data.aws_caller_identity.current.account_id
    oidc_provider_arn  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
    oidc_provider_name = "arn:${local.partition}:iam::${local.account_id}:oidc-provider/${local.oidc_provider_arn}"
}

# Kubernetes provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}

# Helm provider configuration
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}
