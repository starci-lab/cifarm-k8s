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

      master_request_cpu = var.pod_resource_config["xlarge"].requests.cpu,
      master_request_memory = var.pod_resource_config["xlarge"].requests.memory,
      master_limit_cpu = var.pod_resource_config["xlarge"].limits.cpu,
      master_limit_memory = var.pod_resource_config["xlarge"].limits.memory,

      data_request_cpu = var.pod_resource_config["2xlarge"].requests.cpu,
      data_request_memory = var.pod_resource_config["2xlarge"].requests.memory,
      data_limit_cpu = var.pod_resource_config["2xlarge"].limits.cpu,
      data_limit_memory = var.pod_resource_config["2xlarge"].limits.memory,

      coordinating_request_cpu = var.pod_resource_config["xlarge"].requests.cpu,
      coordinating_request_memory = var.pod_resource_config["xlarge"].requests.memory,
      coordinating_limit_cpu = var.pod_resource_config["xlarge"].limits.cpu,
      coordinating_limit_memory = var.pod_resource_config["xlarge"].limits.memory,

      ingest_request_cpu = var.pod_resource_config["xlarge"].requests.cpu,
      ingest_request_memory = var.pod_resource_config["xlarge"].requests.memory,
      ingest_limit_cpu = var.pod_resource_config["xlarge"].limits.cpu,
      ingest_limit_memory = var.pod_resource_config["xlarge"].limits.memory,

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
