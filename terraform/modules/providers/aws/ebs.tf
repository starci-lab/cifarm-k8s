# EBS CSI Driver IAM Role
module "ebs_csi_eks_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = local.ebs_csi_role_name

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = local.oidc_provider_name
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}
