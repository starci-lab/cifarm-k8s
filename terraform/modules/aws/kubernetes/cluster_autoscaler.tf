resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace = var.system_namespace

    values = [
        templatefile("${path.module}/manifests/cluster-autoscaler-values.yaml", {
            cluster_name = var.cluster_name,
            cluster_autoscaler_iam_role_arn = var.cluster_autoscaler_iam_role_arn,
            node_group_label = var.primary_node_group_name
            region = var.region
        })
    ]
}
