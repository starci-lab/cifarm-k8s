# Create namespace for the databases
resource "kubernetes_namespace" "databases" {
    metadata {
        name = "databases"
    }
}

# Helm release for the Gameplay PostgreSQL database
resource "helm_release" "gameplay-postgres" {
    name       = "gameplay-postgres"
    repository = var.bitnami_repository
    chart      = "postgresql-ha"
    namespace  = kubernetes_namespace.databases.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/postgresql-ha-values.yaml", {
            password = var.gameplay_postgres_password,
            database = var.gameplay_postgres_database,
            node_group_label = var.primary_node_group_name
        })
    ]
}   

# Helm release for the Cache Redis database
resource "helm_release" "cache-redis" {
    name       = "cache-redis"
    repository = var.bitnami_repository
    chart      = "redis"
    namespace  = kubernetes_namespace.databases.metadata[0].name
    values = [
        templatefile("${path.module}/manifests/redis-values.yaml", {
            node_group_label = var.primary_node_group_name
        })
    ]
}   

# Helm release for the Adapter Redis database
resource "helm_release" "adapter-redis" {
    name       = "adapter-redis"
    repository = var.bitnami_repository
    chart      = "redis"
    namespace  = kubernetes_namespace.databases.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/redis-values.yaml", {
            node_group_label = var.primary_node_group_name
        })
    ]
}   

# Helm release for the Job Redis database
resource "helm_release" "job-redis" {
    name       = "job-redis"
    repository = var.bitnami_repository
    chart      = "redis"
    namespace  = kubernetes_namespace.databases.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/redis-values.yaml", {
            node_group_label = var.primary_node_group_name
        })
    ]
}
