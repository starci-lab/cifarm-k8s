# Create namespace for the databases
resource "kubernetes_namespace" "jobs" {
  metadata {
    name = "jobs"
  }
}

locals {
  cli = {
    name  = "cli"
    image = "cifarm/cli:latest"
    volume = {
      name       = "cli-db"
      mount_path = "/usr/src/app/db"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "cli_db" {
  metadata {
    name      = local.cli.volume.name
    namespace = kubernetes_namespace.jobs.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "100Mi"
      }
    }
  }

  wait_until_bound = false
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
          name    = "db-init"
          image   = local.cli.image
          command = ["cifarm", "db", "init"]
          volume_mount {
            mount_path = local.cli.volume.mount_path
            name       = local.cli.volume.name
          }
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
        container {
          name    = "db-seed"
          image   = local.cli.image
          command = ["cifarm", "db", "seed"]
          volume_mount {
            mount_path = local.cli.volume.mount_path
            name       = local.cli.volume.name
          }
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
        restart_policy = "Never"

        volume {
          name = local.cli.volume.name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.cli_db.metadata[0].name
          }
        }
      }
    }
    backoff_limit = 4
  }
  wait_for_completion = true
  timeouts {
    create = "2m"
    update = "2m"
  }

}
