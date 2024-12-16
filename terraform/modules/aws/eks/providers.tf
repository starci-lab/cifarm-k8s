# AWS provider configuration
provider "aws" {
  # The AWS region where the resources will be created. This is provided as a variable.
  region     = var.region

  # AWS Access Key for authentication. It should be securely handled (e.g., using environment variables or secrets manager).
  access_key = var.access_key

  # AWS Secret Key for authentication. Again, this should be securely handled.
  secret_key = var.secret_key
}

# AWS Caller Identity
# This data source retrieves the AWS caller identity, which provides information about the currently authenticated AWS account.
# It includes the AWS account ID and the IAM user or role making the request.
data "aws_caller_identity" "current" {}

# AWS Availability Zones
# This data source retrieves the availability zones in the specified AWS region.
# It can be useful for choosing where to deploy resources to ensure high availability.
data "aws_availability_zones" "available" {}

# AWS Partition
# This data source provides the current AWS partition (e.g., "aws" for the standard AWS partition, or "aws-us-gov" for the GovCloud partition).
# This is useful if you are working with multiple AWS regions or partitions (like AWS GovCloud).
data "aws_partition" "current" {}

# Retrieve EKS Cluster Configuration
# This data source retrieves details about an existing EKS cluster by referencing the cluster name.
# The output will contain information about the EKS cluster such as the Kubernetes API server endpoint, certificate authority data, and more.
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks_cluster.name  # The EKS cluster name is dynamically fetched from the `aws_eks_cluster.eks_cluster` resource.
}

# Retrieve EKS Cluster Authentication Configuration
# This data source retrieves the authentication configuration for an EKS cluster.
# It is required for generating kubeconfig to authenticate to the cluster.
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.name  # The EKS cluster name is dynamically fetched from the `aws_eks_cluster.eks_cluster` resource.
}