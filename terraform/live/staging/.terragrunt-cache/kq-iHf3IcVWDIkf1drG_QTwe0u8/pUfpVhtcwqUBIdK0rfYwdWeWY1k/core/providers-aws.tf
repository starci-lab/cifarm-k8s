# AWS Module only - If you are using other cloud providers, you can ignore the file.
# AWS provider
module "provider" {
  source = "../providers/aws"
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "access_key" {
  type = string
  description = "AWS access key"
  sensitive = true
}

variable "secret_key" {
  type = string
  description = "AWS secret key"
  sensitive = true
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
