resource "kubernetes_namespace" "keda" {
  metadata {
    name = "keda"
  }
}

resource "helm_release" "keda" {
  name       = "keda"
  repository = var.keda_repository
  chart      = "keda"
  namespace        = kubernetes_namespace.keda.metadata[0].name
  create_namespace = false

  values = [
    templatefile("${path.module}/manifests/keda-values.yaml",{
        node_group_label = var.primary_node_pool_name,
        operator_request_cpu =  var.pod_resource_config["nano"].requests.cpu
        operator_request_memory =  var.pod_resource_config["nano"].requests.memory
        operator_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        operator_limit_memory = var.pod_resource_config["nano"].limits.memory

        metric_server_request_cpu =  var.pod_resource_config["nano"].requests.cpu
        metric_server_request_memory =  var.pod_resource_config["nano"].requests.memory
        metric_server_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        metric_server_limit_memory = var.pod_resource_config["nano"].limits.memory

        webhooks_request_cpu =  var.pod_resource_config["nano"].requests.cpu
        webhooks_request_memory =  var.pod_resource_config["nano"].requests.memory
        webhooks_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        webhooks_limit_memory = var.pod_resource_config["nano"].limits.memory
        service_monitor_selector = var.service_monitoring_keda 
        interval_scrape = var.scrape_time_config["medium"].interval_scrape
        timeout_scrape = var.scrape_time_config["medium"].timeout_scrape
    })
  ]

  depends_on = [ kubernetes_namespace.keda ]

  timeout = 300
}