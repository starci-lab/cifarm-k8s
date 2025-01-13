# Define an EKS add-on for the VPC CNI (Container Network Interface) plugin
# This add-on is responsible for managing networking in the EKS cluster
resource "aws_eks_addon" "vpc_cni" {
  # The EKS cluster to which the VPC CNI add-on will be associated
  cluster_name = aws_eks_cluster.eks_cluster.name

  # The name of the add-on, in this case, it is the VPC CNI plugin
  addon_name = "vpc-cni"

  configuration_values = jsonencode({
    env = {
      "ENABLE_PREFIX_DELEGATION" = "true"
    }
  })
}

# Define an EKS add-on for kube-proxy
# kube-proxy is responsible for managing network rules for pods
resource "aws_eks_addon" "kube_proxy" {
  # The EKS cluster to which the kube-proxy add-on will be associated
  cluster_name = aws_eks_cluster.eks_cluster.name

  # The name of the add-on, which in this case is kube-proxy
  addon_name = "kube-proxy"

}

# Define an EKS add-on for CoreDNS
# CoreDNS is the default DNS service for EKS clusters, providing DNS resolution for services
resource "aws_eks_addon" "core_dns" {
  # The EKS cluster to which the CoreDNS add-on will be associated
  cluster_name = aws_eks_cluster.eks_cluster.name

  # The name of the add-on, which is CoreDNS
  addon_name = "coredns"

  # Ensure the EKS cluster is created only after the IAM role policies are attached

  depends_on = [
    aws_eks_node_group.primary_node_group,
    aws_eks_node_group.secondary_node_group
  ]
}

# Define an EKS add-on for CoreDNS
# CoreDNS is the default DNS service for EKS clusters, providing DNS resolution for services
resource "aws_eks_addon" "aws_ebs_csi_driver" {
  # The EKS cluster to which the CoreDNS add-on will be associated
  cluster_name = aws_eks_cluster.eks_cluster.name

  # The name of the add-on, which is CoreDNS
  addon_name = "aws-ebs-csi-driver"

  service_account_role_arn = aws_iam_role.aws_ebs_csi_driver.arn

  depends_on = [
    aws_iam_role_policy.aws_ebs_csi_driver,
    aws_eks_node_group.primary_node_group,
    aws_eks_node_group.secondary_node_group
  ]
}

# Define an IAM role for the AWS EBS CSI driver
resource "aws_iam_role" "aws_ebs_csi_driver" {
  name = "iam-role-aws-ebs-csi-driver-${var.cluster_name}" # The IAM role name dynamically set based on the cluster name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow" # The required "Effect" field
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.cluster.arn}" # The OIDC provider URL
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" : "sts.amazonaws.com",
            "${local.oidc_provider}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })

  # Ensure the EKS cluster is created only after the IAM role policies are attached
  depends_on = [aws_iam_openid_connect_provider.cluster]
}

# Define an IAM role policy for the AWS EBS CSI driver
resource "aws_iam_role_policy" "aws_ebs_csi_driver" {
  name = "iam-role-policy-aws-ebs-csi-driver-${var.cluster_name}" # The IAM role policy name dynamically set based on the cluster name
  role = aws_iam_role.aws_ebs_csi_driver.id                       # The IAM role to attach the policy to

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:ModifyVolume",
          "ec2:EnableFastSnapshotRestores",
          "ec2:DetachVolume",
          "ec2:DescribeVolumesModifications",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "ec2:DescribeSnapshots",
          "ec2:DescribeInstances",
          "ec2:DescribeAvailabilityZones",
          "ec2:CreateSnapshot",
          "ec2:AttachVolume"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = "ec2:CreateTags",
        Condition = {
          StringEquals = {
            "ec2:CreateAction" = [
              "CreateVolume",
              "CreateSnapshot"
            ]
          }
        },
        Effect = "Allow",
        Resource = [
          "arn:aws:ec2:*:*:volume/*",
          "arn:aws:ec2:*:*:snapshot/*"
        ]
      },
      {
        Action = "ec2:DeleteTags",
        Effect = "Allow",
        Resource = [
          "arn:aws:ec2:*:*:volume/*",
          "arn:aws:ec2:*:*:snapshot/*"
        ]
      },
      {
        Action = "ec2:CreateVolume",
        Condition = {
          StringLike = {
            "aws:RequestTag/ebs.csi.aws.com/cluster" = "true"
          }
        },
        Effect   = "Allow",
        Resource = "arn:aws:ec2:*:*:volume/*"
      },
      {
        Action = "ec2:CreateVolume",
        Condition = {
          StringLike = {
            "aws:RequestTag/CSIVolumeName" = "*"
          }
        },
        Effect   = "Allow",
        Resource = "arn:aws:ec2:*:*:volume/*"
      },
      {
        Action = "ec2:CreateVolume",
        Condition = {
          StringLike = {
            "aws:RequestTag/kubernetes.io/cluster/*" = "owned"
          }
        },
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action   = "ec2:CreateVolume",
        Effect   = "Allow",
        Resource = "arn:aws:ec2:*:*:snapshot/*"
      },
      {
        Action = "ec2:DeleteVolume",
        Condition = {
          StringLike = {
            "ec2:ResourceTag/ebs.csi.aws.com/cluster" = "true"
          }
        },
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = "ec2:DeleteVolume",
        Condition = {
          StringLike = {
            "ec2:ResourceTag/CSIVolumeName" = "*"
          }
        },
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = "ec2:DeleteVolume",
        Condition = {
          StringLike = {
            "ec2:ResourceTag/kubernetes.io/cluster/*" = "owned"
          }
        },
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = "ec2:DeleteVolume",
        Condition = {
          StringLike = {
            "ec2:ResourceTag/kubernetes.io/created-for/pvc/name" = "*"
          }
        },
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = "ec2:DeleteSnapshot",
        Condition = {
          StringLike = {
            "ec2:ResourceTag/CSIVolumeSnapshotName" = "*"
          }
        },
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = "ec2:DeleteSnapshot",
        Condition = {
          StringLike = {
            "ec2:ResourceTag/ebs.csi.aws.com/cluster" = "true"
          }
        },
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
