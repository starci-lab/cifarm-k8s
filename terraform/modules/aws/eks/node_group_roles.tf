# IAM Role for Primary Node Group
resource "aws_iam_role" "primary_node_group" {
  # Name of the IAM role for the primary node group, dynamically generated based on the cluster name
  name = "iam-role-primary-${var.cluster_name}"

  # Assume role policy that allows EC2 instances to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"  # The action that is allowed (AssumeRole)
        Effect = "Allow"           # The effect is Allow
        Sid    = ""                # Optional statement ID, left empty here
        Principal = {
          Service = "ec2.amazonaws.com"  # Specifies that EC2 instances can assume this role
        }
      },
    ]
  })
}

# Attach Amazon EKS Worker Node Policy to the primary node group role
resource "aws_iam_role_policy_attachment" "primary_node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"  # EKS Worker Node Policy ARN
  role       = aws_iam_role.primary_node_group.name                # Attach it to the primary node group IAM role
}

# Attach Amazon EKS CNI Policy to the primary node group role
resource "aws_iam_role_policy_attachment" "primary_node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  # EKS CNI Plugin Policy ARN
  role       = aws_iam_role.primary_node_group.name             # Attach it to the primary node group IAM role
}

# Attach Amazon EC2 Container Registry Read-Only Policy to the primary node group role
resource "aws_iam_role_policy_attachment" "primary_node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"  # ECR Read-Only Policy ARN
  role       = aws_iam_role.primary_node_group.name                            # Attach it to the primary node group IAM role
}

############################################

# IAM Role for Secondary Node Group
resource "aws_iam_role" "secondary_node_group" {
  # Name of the IAM role for the secondary node group, dynamically generated based on the cluster name
  name = "iam-role-secondary-${var.cluster_name}"

  # Assume role policy that allows EC2 instances to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"  # The action that is allowed (AssumeRole)
        Effect = "Allow"           # The effect is Allow
        Sid    = ""                # Optional statement ID, left empty here
        Principal = {
          Service = "ec2.amazonaws.com"  # Specifies that EC2 instances can assume this role
        }
      },
    ]
  })
}

# Attach Amazon EKS Worker Node Policy to the secondary node group role
resource "aws_iam_role_policy_attachment" "secondary_node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"  # EKS Worker Node Policy ARN
  role       = aws_iam_role.secondary_node_group.name               # Attach it to the secondary node group IAM role
}

# Attach Amazon EKS CNI Policy to the secondary node group role
resource "aws_iam_role_policy_attachment" "secondary_node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  # EKS CNI Plugin Policy ARN
  role       = aws_iam_role.secondary_node_group.name            # Attach it to the secondary node group IAM role
}

# Attach Amazon EC2 Container Registry Read-Only Policy to the secondary node group role
resource "aws_iam_role_policy_attachment" "secondary_node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"  # ECR Read-Only Policy ARN
  role       = aws_iam_role.secondary_node_group.name                             # Attach it to the secondary node group IAM role
}