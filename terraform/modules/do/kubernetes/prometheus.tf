resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = var.bitnami_repository
  chart      = "kube-prometheus"
  namespace        = kubernetes_namespace.prometheus.metadata[0].name
  create_namespace = false

  values = [
    templatefile("${path.module}/manifests/prometheus-values.yaml",{
        node_group_label = var.primary_node_pool_name,
        alertmanager_request_cpu =  var.pod_resource_config["nano"].requests.cpu
        alertmanager_request_memory =  var.pod_resource_config["nano"].requests.memory
        alertmanager_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        alertmanager_limit_memory = var.pod_resource_config["nano"].limits.memory

        blackbox_exporter_request_cpu =  var.pod_resource_config["nano"].requests.cpu
        blackbox_exporter_request_memory =  var.pod_resource_config["nano"].requests.memory
        blackbox_exporter_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        blackbox_exporter_limit_memory = var.pod_resource_config["nano"].limits.memory

        operator_request_cpu =  var.pod_resource_config["nano"].requests.cpu
        operator_request_memory =  var.pod_resource_config["nano"].requests.memory
        operator_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        operator_limit_memory = var.pod_resource_config["nano"].limits.memory

        prometheus_request_cpu =  var.pod_resource_config["nano"].requests.cpu
        prometheus_request_memory =  var.pod_resource_config["nano"].requests.memory
        prometheus_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        prometheus_limit_memory = var.pod_resource_config["nano"].limits.memory

        thanos_request_cpu =  var.pod_resource_config["nano"].requests.cpu
        thanos_request_memory =  var.pod_resource_config["nano"].requests.memory
        thanos_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        thanos_limit_memory = var.pod_resource_config["nano"].limits.memory

        node_exporter_request_cpu =  var.pod_resource_config["nano"].requests.cpu
        node_exporter_request_memory =  var.pod_resource_config["nano"].requests.memory
        node_exporter_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        node_exporter_limit_memory = var.pod_resource_config["nano"].limits.memory

        kube_state_metrics_request_cpu =  var.pod_resource_config["nano"].requests.cpu
        kube_state_metrics_request_memory =  var.pod_resource_config["nano"].requests.memory
        kube_state_metrics_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        kube_state_metrics_limit_memory = var.pod_resource_config["nano"].limits.memory
        service_monitor_selector= var.service_monitoring_keda 
        service_monitor_namespace_selector= kubernetes_namespace.keda.metadata[0].name
    })
  ]

  depends_on = [ kubernetes_namespace.prometheus ]

  timeout = 300
}