# AWS EKS OIDC Provider
resource "aws_iam_openid_connect_provider" "cluster" {
  # The URL of the OIDC provider for the EKS cluster
  url = local.oidc_issuer
  
  # The list of client IDs that are associated with the OIDC provider
  client_id_list = [
    "sts.amazonaws.com"
  ]

  # The list of thumbprints of the OIDC provider's server certificates
  thumbprint_list = []
  
  # Ensure the EKS OIDC provider is created only after the EKS cluster is created
  depends_on = [ aws_eks_cluster.eks_cluster ]
}

# Local Variables
locals {
    # The cluster name is passed from the `var.cluster_name` variable, which is used throughout the configuration.
    cluster_name = var.cluster_name  
    
    # Retrieves the AWS partition (e.g., "aws", "aws-us-gov").
    partition = data.aws_partition.current.id  

    # Retrieves the AWS account ID from the caller identity.
    account_id = data.aws_caller_identity.current.account_id  

    # OIDC provider ARN (AWS OpenID Connect) is generated from the EKS cluster's OIDC issuer URL.
    # The issuer URL contains the `oidc` endpoint, and the "https://" prefix is removed to form the full ARN.
    oidc_issuer = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
    oidc_provider = replace(local.oidc_issuer, "https://", "")
}
