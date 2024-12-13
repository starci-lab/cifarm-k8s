
# Storage Class
resource "kubernetes_storage_class" "storageclass_gp2" {
  metadata {
    name = "gp2-encrypted"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"

  parameters = {
    type      = "gp2"
    encrypted = "true"
  }
}

resource "kubernetes_service_account" "service-account" {
 metadata {
     name      = "aws-load-balancer-controller"
     namespace = "kube-system"
     labels = {
     "app.kubernetes.io/name"      = "aws-load-balancer-controller"
     "app.kubernetes.io/component" = "controller"
     }
     annotations = {
     "eks.amazonaws.com/role-arn"               = module.provider.lb_role_arn
     "eks.amazonaws.com/sts-regional-endpoints" = "true"
     }
  }
}

resource "helm_release" "ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    type  = "string"
    value = module.provider.ebs_csi_eks_role_arn
  }
}