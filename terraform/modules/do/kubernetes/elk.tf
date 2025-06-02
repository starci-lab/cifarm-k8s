resource "kubernetes_namespace" "elk" {
  metadata {
    name = "elk"
  }
}

locals {
  # Elasticsearch Configuration
  elasticsearch = {
    name = "elasticsearch"
    host = "elasticsearch.${kubernetes_namespace.elk.metadata[0].name}.svc.cluster.local"
    port = 9200
  }
  # Kibana Configuration
  kibana = {
    name = "kibana"
    host = "kibana.${kubernetes_namespace.elk.metadata[0].name}.svc.cluster.local"
    port = 5601
  }
}

resource "helm_release" "elasticsearch" {
  name            = local.elasticsearch.name
  repository      = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "elasticsearch"
  namespace       = kubernetes_namespace.elk.metadata[0].name

 values = [
    templatefile("${path.module}/manifests/elasticsearch-values.yaml", {
      node_pool_label = var.primary_node_pool_name,

      master_request_cpu = var.pod_resource_config["large"].requests.cpu,
      master_request_memory = var.pod_resource_config["large"].requests.memory,
      master_limit_cpu = var.pod_resource_config["large"].limits.cpu,
      master_limit_memory = var.pod_resource_config["large"].limits.memory,

      data_request_cpu = var.pod_resource_config["large"].requests.cpu,
      data_request_memory = var.pod_resource_config["large"].requests.memory,
      data_limit_cpu = var.pod_resource_config["large"].limits.cpu,
      data_limit_memory = var.pod_resource_config["large"].limits.memory,

      coordinating_request_cpu = var.pod_resource_config["large"].requests.cpu,
      coordinating_request_memory = var.pod_resource_config["large"].requests.memory,
      coordinating_limit_cpu = var.pod_resource_config["large"].limits.cpu,
      coordinating_limit_memory = var.pod_resource_config["large"].limits.memory,

      ingest_request_cpu = var.pod_resource_config["large"].requests.cpu,
      ingest_request_memory = var.pod_resource_config["large"].requests.memory,
      ingest_limit_cpu = var.pod_resource_config["large"].limits.cpu,
      ingest_limit_memory = var.pod_resource_config["large"].limits.memory,

      elasticsearch_password = var.elasticsearch_password,
      kibana_username = var.kibana_username,
      kibana_password = var.kibana_password,

      master_persistence_size = var.master_persistence_size,
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

resource "helm_release" "kibana" {
  name            = local.kibana.name
  repository      = var.bitnami_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "kibana"
  namespace       = kubernetes_namespace.elk.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/kibana-values.yaml", {
      node_pool_label = var.primary_node_pool_name,
      kibana_username = var.kibana_username,
      kibana_password = var.kibana_password,

      kibana_cpu_request = var.pod_resource_config["micro"].requests.cpu,
      kibana_memory_request = var.pod_resource_config["micro"].requests.memory,
      kibana_cpu_limit = var.pod_resource_config["micro"].limits.cpu,
      kibana_memory_limit = var.pod_resource_config["micro"].limits.memory,
      
      elasticsearch_host = local.elasticsearch.host,
      elasticsearch_port = local.elasticsearch.port,

      kibana_persistence_size = var.kibana_persistence_size,
    })
  ]

  dynamic "set" {
    for_each = local.set_pull_secrets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  depends_on = [helm_release.elasticsearch]
}
