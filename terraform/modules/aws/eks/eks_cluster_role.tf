# Create an IAM role for the EKS cluster with an assume role policy
resource "aws_iam_role" "eks_cluster" {
  name = "iam-role-eks-cluster-${var.cluster_name}"  # The IAM role name dynamically set based on the cluster name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = [
              "sts:AssumeRole",  # Allows assuming the role
              "sts:TagSession"   # Allows tagging the session
            ]
            Effect = "Allow"  # This is an allow policy
            Principal = {
              Service = "eks.amazonaws.com"  # The service that can assume the role (EKS in this case)
            }
        },
    ]
  })
}

# Create an IAM role policy for the EKS cluster
resource "aws_iam_role_policy" "cluster" {
  name = "iam-role-policy-eks-cluster-${var.cluster_name}"  # The IAM role policy name dynamically set based on the cluster name
  role = aws_iam_role.eks_cluster.name  # The IAM role to attach the policy to

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:ListFargateProfiles",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:ListUpdates",
          "eks:AccessKubernetesApi",
          "eks:ListAddons",
          "eks:DescribeCluster",
          "eks:DescribeAddonVersions",
          "eks:ListClusters",
          "eks:ListIdentityProviderConfigs",
          "iam:ListRoles"
        ]
        Effect   = "Allow"
        Resource = "*",
      },
    ]
  })
}

# Attach Amazon EKS Cluster Policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  # The ARN of the EKS Cluster Policy
  role       = aws_iam_role.eks_cluster.name  # The IAM role to attach the policy to
}

# Attach Amazon EKS Compute Policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSComputePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"  # The ARN of the EKS Compute Policy
  role       = aws_iam_role.eks_cluster.name  # The IAM role to attach the policy to
}

# Attach Amazon EKS Block Storage Policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSBlockStoragePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"  # The ARN of the EKS Block Storage Policy
  role       = aws_iam_role.eks_cluster.name  # The IAM role to attach the policy to
}

# Attach Amazon EKS Load Balancing Policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSLoadBalancingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"  # The ARN of the EKS Load Balancing Policy
  role       = aws_iam_role.eks_cluster.name  # The IAM role to attach the policy to
}

# Attach Amazon EKS Networking Policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSNetworkingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"  # The ARN of the EKS Networking Policy
  role       = aws_iam_role.eks_cluster.name  # The IAM role to attach the policy to
}