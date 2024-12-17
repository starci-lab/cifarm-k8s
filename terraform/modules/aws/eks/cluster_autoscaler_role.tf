# Define an IAM role for the AWS EBS CSI driver
resource "aws_iam_role" "cluster_autoscaler" {
  name = "cluster-autoscaler-${var.cluster_name}" # The IAM role name dynamically set based on the cluster name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"  # The required "Effect" field
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.cluster.arn}" # The OIDC provider URL
        },
        Action   = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" : "sts.amazonaws.com",
            "${local.oidc_provider}:sub" : "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      }
    ]
  })

  # Ensure the EKS cluster is created only after the IAM role policies are attached
  depends_on = [ aws_iam_openid_connect_provider.cluster ]
}

# Define an IAM role policy for the AWS EBS CSI driver
resource "aws_iam_role_policy" "cluster_autoscaler" {
  name = "cluster-autoscaler-${var.cluster_name}"  # The IAM role policy name dynamically set based on the cluster name
  role = aws_iam_role.cluster_autoscaler.id  # The IAM role to attach the policy to

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
          "Action": [
              "autoscaling:DescribeAutoScalingGroups",
              "autoscaling:DescribeAutoScalingInstances",
              "autoscaling:DescribeLaunchConfigurations",
              "autoscaling:DescribeTags",
              "autoscaling:SetDesiredCapacity",
              "autoscaling:TerminateInstanceInAutoScalingGroup",
              "ec2:DescribeLaunchTemplateVersions"
          ],
          "Resource": "*",
          "Effect": "Allow"
      }
  ]
  })
}
