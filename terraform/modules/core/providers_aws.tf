# AWS Module only - If you are using other cloud providers, you can ignore the file.
# AWS provider
module "provider" {
  source = "../providers/aws"
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region

  # EKS cluster
  cluster_base_name = var.cluster_base_name

  ## Primary Node Group
  primary_node_base_group_name = var.primary_node_base_group_name
  primary_node_instance_type = var.primary_node_instance_type
  min_size_primary_node_group = var.min_size_primary_node_group
  max_size_primary_node_group = var.max_size_primary_node_group
  desired_size_primary_node_group = var.desired_size_primary_node_group
  disk_size_primary_node_group = var.disk_size_primary_node_group

  ## EKS cluster - Secondary Node Group
  secondary_node_base_group_name = var.secondary_node_base_group_name
  secondary_node_instance_type = var.secondary_node_instance_type
  min_size_secondary_node_group = var.min_size_secondary_node_group
  max_size_secondary_node_group = var.max_size_secondary_node_group
  desired_size_secondary_node_group = var.desired_size_secondary_node_group
  disk_size_secondary_node_group = var.disk_size_secondary_node_group
}

# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = module.provider.cluster_name
}

# Retrieve EKS cluster auth configuration
data "aws_eks_cluster_auth" "cluster" {
  name = module.provider.cluster_name
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

data "aws_availability_zones" "available" {
  
}