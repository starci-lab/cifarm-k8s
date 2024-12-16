resource "aws_eks_cluster" "eks_cluster" {
  # The name of the EKS cluster, dynamically set from the variable `var.cluster_name`
  name     = var.cluster_name

  # The ARN of the IAM role that the EKS cluster will assume for its operations
  role_arn = aws_iam_role.eks_cluster.arn

  # Specify the Kubernetes version to use for the EKS cluster
  version  = "1.31"

  # Define the access configuration for the EKS cluster
  access_config {
    # Authentication mode set to API for accessing the Kubernetes API
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  # Define the networking configuration for the Kubernetes cluster
  kubernetes_network_config {
    elastic_load_balancing {
      # Enable Elastic Load Balancing for services in the cluster
      enabled = true
    }
  }

  # Define the compute configuration for the EKS cluster
  compute_config {
    enabled = true
  }

  # Define the storage configuration for the EKS cluster
  storage_config {
    block_storage {
      # Enable the block storage feature for the EKS cluster
      enabled = true
    }
  }
 
  # Disable the bootstrap of self-managed add-ons for the EKS cluster
  bootstrap_self_managed_addons = false

  # Configure the VPC settings for the EKS cluster
  vpc_config {
    # Enable private access to the Kubernetes API endpoint within the VPC
    endpoint_private_access = true
    # Enable public access to the Kubernetes API endpoint
    endpoint_public_access  = true

    # Provide the subnet IDs that the EKS cluster should use for its worker nodes
    subnet_ids = var.private_subnet_ids
  }

  # Ensure the EKS cluster is created only after the IAM role policies are attached
  depends_on = [
    # Attach the necessary IAM policies to the EKS cluster's IAM role
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSComputePolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSNetworkingPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSBlockStoragePolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSLoadBalancingPolicy
  ]
}