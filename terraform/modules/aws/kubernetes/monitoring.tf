# Namespace for monitoring resources
resource "kubernetes_namespace" "monitoring" {
    metadata {
        name = "monitoring"
    }
}


# Helm release for the Gameplay PostgreSQL database
resource "helm_release" "prometheus" {
    name       = "prometheus"
    repository = var.bitnami_repository
    chart      = "kube-prometheus"
    namespace  = kubernetes_namespace.monitoring.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/prometheus-values.yaml", {
            node_group_label = var.secondary_node_group_name,
            // Add the resource requests and limits for the Prometheus components
            alertmanager_request_memory = var.pod_resource_config["nano"].requests.memory,
            alertmanager_request_cpu = var.pod_resource_config["nano"].requests.cpu,
            alertmanager_limit_memory = var.pod_resource_config["nano"].limits.memory,
            alertmanager_limit_cpu = var.pod_resource_config["nano"].limits.cpu,
            blackbox_exporter_request_memory = var.pod_resource_config["nano"].requests.memory,
            blackbox_exporter_request_cpu = var.pod_resource_config["nano"].requests.cpu,
            blackbox_exporter_limit_memory = var.pod_resource_config["nano"].limits.memory,
            blackbox_exporter_limit_cpu = var.pod_resource_config["nano"].limits.cpu,
            operator_request_memory = var.pod_resource_config["micro"].requests.memory,
            operator_request_cpu = var.pod_resource_config["micro"].requests.cpu,
            operator_limit_memory = var.pod_resource_config["micro"].limits.memory,
            operator_limit_cpu = var.pod_resource_config["micro"].limits.cpu,
            prometheus_request_memory = var.pod_resource_config["small"].requests.memory,
            prometheus_request_cpu = var.pod_resource_config["small"].requests.cpu,
            prometheus_limit_memory = var.pod_resource_config["small"].limits.memory,
            prometheus_limit_cpu = var.pod_resource_config["small"].limits.cpu,
            thanos_request_memory = var.pod_resource_config["nano"].requests.memory,
            thanos_request_cpu = var.pod_resource_config["nano"].requests.cpu,
            thanos_limit_memory = var.pod_resource_config["nano"].limits.memory,
            thanos_limit_cpu = var.pod_resource_config["nano"].limits.cpu,
            node_exporter_request_memory = var.pod_resource_config["nano"].requests.memory,
            node_exporter_request_cpu = var.pod_resource_config["nano"].requests.cpu,
            node_exporter_limit_memory = var.pod_resource_config["nano"].limits.memory,
            node_exporter_limit_cpu = var.pod_resource_config["nano"].limits.cpu,
            kube_state_metrics_request_memory = var.pod_resource_config["nano"].requests.memory,
            kube_state_metrics_request_cpu = var.pod_resource_config["nano"].requests.cpu,
            kube_state_metrics_limit_memory = var.pod_resource_config["nano"].limits.memory,
            kube_state_metrics_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        })
    ]
}   

# Helm release for the Grafana 
resource "helm_release" "grafana" {
    name       = "grafana"
    repository = var.bitnami_repository
    chart      = "grafana"
    namespace  = kubernetes_namespace.monitoring.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/grafana-values.yaml", {
            user = var.grafana_user,
            password = var.grafana_password,
            prometheus_url = var.grafana_prometheus_url,
            prometheus_alertmanager_url = var.grafana_prometheus_alertmanager_url,
            node_group_label = var.secondary_node_group_name,
            request_cpu = var.pod_resource_config["small"].requests.cpu,
            request_memory = var.pod_resource_config["small"].requests.memory,
            limit_cpu = var.pod_resource_config["small"].limits.cpu,
            limit_memory = var.pod_resource_config["small"].limits.memory
        })
    ]
}

# resources:
#   operator:
#     requests:
#       cpu: ${operator_request_cpu}
#       memory: ${operator_request_memory}
#     limits:
#       cpu: ${operator_limit_cpu}
#       memory: ${operator_limit_memory}

#   metricServer:
#     requests:
#     requests:
#       cpu: ${metric_server_request_cpu}
#       memory: ${metric_server_request_memory}
#     limits:
#       cpu: ${metric_server_limit_cpu}
#       memory: ${metric_server_limit_memory}

#   webhooks:
#     requests:
#       cpu: ${webhooks_request_cpu}
#       memory: ${webhooks_request_memory}
#     limits:
#       cpu: ${webhooks_limit_cpu}
#       memory: "${webhooks_limit_memory}"
# Helm release for the Keda
resource "helm_release" "keda" {
    name       = "keda"
    repository = var.keda_repository
    chart      = "keda"
    namespace  = kubernetes_namespace.monitoring.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/keda-values.yaml", {
            node_group_label = var.secondary_node_group_name,
            // Add the resource requests and limits for the Keda components
            operator_request_memory = var.pod_resource_config["nano"].requests.memory,
            operator_request_cpu = var.pod_resource_config["nano"].requests.cpu,
            operator_limit_memory = var.pod_resource_config["nano"].limits.memory,
            operator_limit_cpu = var.pod_resource_config["nano"].limits.cpu,
            metric_server_request_memory = var.pod_resource_config["nano"].requests.memory,
            metric_server_request_cpu = var.pod_resource_config["nano"].requests.cpu,
            metric_server_limit_memory = var.pod_resource_config["nano"].limits.memory,
            metric_server_limit_cpu = var.pod_resource_config["nano"].limits.cpu,
            webhooks_request_memory = var.pod_resource_config["nano"].requests.memory,
            webhooks_request_cpu = var.pod_resource_config["nano"].requests.cpu,
            webhooks_limit_memory = var.pod_resource_config["nano"].limits.memory,
            webhooks_limit_cpu = var.pod_resource_config["nano"].limits.cpu
        })
    ]
}

# Helm release for the Portainer
# resource "helm_release" "portainer" {
#     name       = "portainer"
#     repository = var.bitnami_repository
#     chart      = "portainer"
#     namespace  = kubernetes_namespace.monitoring.metadata[0].name

#     values = [
#         templatefile("${path.module}/manifests/portainer-values.yaml", {
#             node_group_label = var.secondary_node_group_name
#         })
#     ]
# }