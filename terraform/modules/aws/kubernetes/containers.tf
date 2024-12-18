# Create namespace for the databases
resource "kubernetes_namespace" "containers" {
  metadata {
    name = "containers"
  }
}

resource "helm_release" "gameplay_service" {
  name       = "gameplay-service"
  repository = var.container_repository
  chart      = "deployment"
  namespace  = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/gameplay-service-values.yaml", {
      node_group_label           = var.primary_node_group_name,
      jwt_secret                 = var.jwt_secret,
      gameplay_postgres_database = var.gameplay_postgres_database,
      gameplay_postgres_password = var.gameplay_postgres_password,
    })
  ]

  depends_on = [
    helm_release.keda
  ]
}
