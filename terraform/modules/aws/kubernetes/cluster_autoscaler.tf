resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = var.cluster_autoscaler_repository
  chart      = "cluster-autoscaler"
  namespace = var.system_namespace

    values = [
        templatefile("${path.module}/manifests/cluster-autoscaler-values.yaml", {
            cluster_name = var.cluster_name,
            cluster_autoscaler_iam_role_arn = var.cluster_autoscaler_iam_role_arn,
            node_group_label = var.primary_node_group_name
            region = var.region,
            request_cpu  = local.pod_resource_config["micro"].requests.cpu
            request_memory = local.pod_resource_config["micro"].requests.memory
            limit_cpu    = local.pod_resource_config["micro"].limits.cpu
            limit_memory = local.pod_resource_config["micro"].limits.memory
        })
    ]
}
