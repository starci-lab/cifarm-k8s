# Create namespace for the databases
resource "kubernetes_namespace" "jobs" {
  metadata {
    name = "jobs"
  }
}

locals {
  cli = {
    image = "cifarm/cli:latest"
  }
}
resource "kubernetes_job" "seed_db" {
  metadata {
    name      = "seed-db"
    namespace = kubernetes_namespace.jobs.metadata[0].name
  }
  spec {
    template {
      metadata {}
      spec {
        image_pull_secrets {
          name = kubernetes_secret.docker_credentials.metadata[0].name
        }
        container {
          name    = "seed-db"
          image   = local.cli.image
          command = ["cifarm", "db", "seed", "-c", "-f"]
          resources {
            requests = {
              cpu    = var.pod_resource_config["micro"].requests.cpu,
              memory = var.pod_resource_config["micro"].requests.memory
            }
            limits = {
              cpu    = var.pod_resource_config["micro"].limits.cpu,
              memory = var.pod_resource_config["micro"].limits.memory
            }
          }
          env {
            name  = "GAMEPLAY_MONGODB_DBNAME"
            value = local.gameplay_mongodb.database
          }

          env {
            name  = "GAMEPLAY_MONGODB_HOST"
            value = local.gameplay_mongodb.host
          }

          env {
            name  = "GAMEPLAY_MONGODB_PORT"
            value = local.gameplay_mongodb.port
          }

          env {
            name  = "GAMEPLAY_MONGODB_USERNAME"
            value = var.gameplay_mongodb_username
          }

          env {
            name  = "GAMEPLAY_MONGODB_PASSWORD"
            value = var.gameplay_mongodb_password
          }

          env {
            name  = "CACHE_REDIS_HOST"
            value = local.cache_redis.host
          }

          env {
            name  = "CACHE_REDIS_PORT"
            value = local.cache_redis.port
          }

          env {
            name  = "CACHE_REDIS_PASSWORD"
            value = var.cache_redis_password
          }

          env {
            name  = "CACHE_REDIS_CLUSTER_ENABLED"
            value = true
          }

          env {
            name  = "CACHE_REDIS_CLUSTER_RUN_IN_DOCKER"
            value = false
          }

          env {
            name  = "SOLANA_HONEYCOMB_AUTHORITY_PRIVATE_KEY_MAINNET"
            value = var.solana_honeycomb_authority_private_key_mainnet
          }

          env {
            name  = "SOLANA_HONEYCOMB_AUTHORITY_PRIVATE_KEY_TESTNET"
            value = var.solana_honeycomb_authority_private_key_testnet
          }

          env {
            name  = "CACHE_REDIS_HOST"
            value = local.cache_redis.host
          }
          env {
            name  = "SOLANA_METAPLEX_AUTHORITY_PRIVATE_KEY_MAINNET"
            value = var.solana_metaplex_authority_private_key_mainnet
          }
          env {
            name  = "SOLANA_METAPLEX_AUTHORITY_PRIVATE_KEY_TESTNET"
            value = var.solana_metaplex_authority_private_key_testnet
          }
          env {
            name  = "FARCASTER_SIGNER_UUID"
            value = var.farcaster_signer_uuid
          }
          env {
            name  = "FARCASTER_API_KEY"
            value = var.farcaster_api_key
          }
        }
      }
    }
    backoff_limit = 3
  }
  wait_for_completion = true
  timeouts {
    create = "4m"
    update = "4m"
  }
  depends_on = [
    helm_release.gameplay_mongodb
  ]
}
