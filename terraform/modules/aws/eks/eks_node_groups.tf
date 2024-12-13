# Primary Node Group
resource "aws_eks_node_group" "primary_node_group" {
  # Reference to the EKS cluster name
  cluster_name    = aws_eks_cluster.eks_cluster.name
  
  # Name of the primary node group
  node_group_name = "primary-${var.cluster_name}"

  # IAM role for primary node group
  node_role_arn   = aws_iam_role.primary_node_group.arn

  # Subnet IDs where the nodes will be launched
  subnet_ids      = module.vpc.private_subnet_ids

  # Scaling configuration: define the desired, maximum, and minimum size for the node group
  scaling_config {
    desired_size = var.desired_size_primary_node_group  # The desired number of nodes in the node group
    max_size     = var.max_size_primary_node_group  # The maximum number of nodes that can be scaled up to
    min_size     = var.min_size_primary_node_group  # The minimum number of nodes to keep running
  }

  # Update configuration: control the maximum number of unavailable nodes during an update
  update_config {
    max_unavailable = 1  # Allow 1 node to be unavailable during updates
  }

  # Ensure that IAM Role policies are applied before the node group is created
  depends_on = [
    aws_iam_role_policy_attachment.primary_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.primary_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.primary_node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}

############################################

# Secondary Node Group
resource "aws_eks_node_group" "secondary_node_group" {
  # Reference to the EKS cluster name
  cluster_name    = aws_eks_cluster.eks_cluster.name

  # Name of the secondary node group
  node_group_name = "secondary-${var.cluster_name}"

  # IAM role for secondary node group
  node_role_arn   = aws_iam_role.secondary_node_group.arn

  # Subnet IDs where the nodes will be launched
  subnet_ids      = module.vpc.private_subnet_ids

  # Scaling configuration for secondary node group
  scaling_config {
    desired_size = var.desired_size_secondary_node_group  # The desired number of nodes in the node group
    max_size     = var.max_size_secondary_node_group  # The maximum number of nodes that can be scaled up to
    min_size     = var.min_size_secondary_node_group  # The minimum number of nodes to keep running
  }

  # Update configuration for secondary node group
  update_config {
    max_unavailable = 1  # Allow 1 node to be unavailable during updates
  }

  # Ensure that IAM Role policies are applied before the node group is created
  depends_on = [
    aws_iam_role_policy_attachment.secondary_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.secondary_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.secondary_node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}