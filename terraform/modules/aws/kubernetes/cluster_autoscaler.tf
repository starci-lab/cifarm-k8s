resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = var.cluster_autoscaler_repository
  chart      = "cluster-autoscaler"
  namespace  = var.system_namespace

  values = [
    templatefile("${path.module}/manifests/cluster-autoscaler-values.yaml", {
      cluster_name                    = var.cluster_name,
      cluster_autoscaler_iam_role_arn = var.cluster_autoscaler_iam_role_arn,
      node_group_label                = var.primary_node_group_name
      region                          = var.region,
      request_cpu                     = var.pod_resource_config["micro"].requests.cpu
      request_memory                  = var.pod_resource_config["micro"].requests.memory
      limit_cpu                       = var.pod_resource_config["micro"].limits.cpu
      limit_memory                    = var.pod_resource_config["micro"].limits.memory
    })
  ]

  dynamic "set" {
    for_each = local.set_pull_secrets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}
