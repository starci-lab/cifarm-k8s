# Create namespace for the databases
resource "kubernetes_namespace" "jobs" {
  metadata {
    name = "jobs"
  }
}

locals {
  cli = {
    name        = "cli"
    image       = "cifarm/cli:latest"
  }
}
resource "kubernetes_job" "cli" {
  metadata {
    name      = local.cli.name
    namespace = kubernetes_namespace.jobs.metadata[0].name
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "seed-db"
          image   = local.cli.image
          command = ["cifarm", "db", "seed"]
          resources {
            requests = {
              cpu    = var.pod_resource_config["nano"].requests.cpu,
              memory = var.pod_resource_config["nano"].requests.memory
            }
            limits = {
              cpu    = var.pod_resource_config["nano"].limits.cpu,
              memory = var.pod_resource_config["nano"].limits.memory
            }
          }
          env {
            name  = "GAMEPLAY_POSTGRESQL_DBNAME"
            value = var.gameplay_postgresql_database
          }

          env {
            name  = "GAMEPLAY_POSTGRESQL_HOST"
            value = local.gameplay_postgresql.host
          }

          env {
            name  = "GAMEPLAY_POSTGRESQL_PORT"
            value = local.gameplay_postgresql.port
          }

          env {
            name  = "GAMEPLAY_POSTGRESQL_USERNAME"
            value = local.gameplay_postgresql.username
          }

          env {
            name  = "GAMEPLAY_POSTGRESQL_PASSWORD"
            value = var.gameplay_postgresql_password
          }
        }
      }
    }
    backoff_limit = 3
  }
  wait_for_completion = true
  timeouts {
    create = "2m"
    update = "2m"
  }

}
