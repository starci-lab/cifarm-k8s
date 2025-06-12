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
    annotations = {
      "backup/version" = "v2"
    }
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
          env {
            name  = "S3_DIGITALOCEAN1_ENDPOINT"
            value = var.s3_digitalocean1_endpoint
          }
          env {
            name  = "S3_DIGITALOCEAN1_ACCESS_KEY_ID"
            value = var.s3_digitalocean1_access_key_id
          }
          env {
            name  = "S3_DIGITALOCEAN1_SECRET_ACCESS_KEY"
            value = var.s3_digitalocean1_secret_access_key
          }
          env {
            name  = "S3_DIGITALOCEAN1_REGION"
            value = var.s3_digitalocean1_region
          }
          env {
            name  = "S3_DIGITALOCEAN1_BUCKET_NAME"
            value = var.s3_digitalocean1_bucket_name
          }
          env {
            name  = "CIPHER_SECRET"
            value = var.cipher_secret
          }
          env {
            name  = "GOOGLE_CLOUD_DRIVER_CLIENT_EMAIL"
            value = var.google_cloud_driver_client_email
          }
          env {
            name  = "GOOGLE_CLOUD_DRIVER_PRIVATE_KEY"
            value = var.google_cloud_driver_private_key
          }
          env {
            name  = "GOOGLE_CLOUD_DRIVER_FOLDER_ID"
            value = var.google_cloud_driver_folder_id
          }
          env {
            name  = "GOOGLE_CLOUD_OAUTH_CLIENT_ID"
            value = var.google_cloud_oauth_client_id
          }
          env {
            name  = "GOOGLE_CLOUD_OAUTH_CLIENT_SECRET"
            value = var.google_cloud_oauth_client_secret
          }
          env {
            name  = "GOOGLE_CLOUD_OAUTH_REDIRECT_URI"
            value = var.google_cloud_oauth_redirect_uri
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

resource "kubernetes_cron_job_v1" "backup_db" {
  metadata {
    name      = "backup-db"
    namespace = kubernetes_namespace.jobs.metadata[0].name
    annotations = {
      "backup/version" = "v3"
    }
  }
  

  spec {
    schedule                      = "0 * * * *" # mỗi giờ
    successful_jobs_history_limit = 3
    failed_jobs_history_limit     = 1
    concurrency_policy            = "Forbid"

    job_template {
      metadata {}

      spec {
        template {
          metadata {
            labels = {
              app = "backup-db"
            }
          }

          spec {
            restart_policy = "Never"

            volume {
              name = "backup-volume"
              empty_dir {} # temporary storage for job
            }

            image_pull_secrets {
              name = kubernetes_secret.docker_credentials.metadata[0].name
            }

            container {
              name    = "backup-db"
              image   = local.cli.image
              command = ["cifarm", "db", "backup"]

              volume_mount {
                name       = "backup-volume"
                mount_path = "/etc/backups"
              }

              resources {
                requests = {
                  cpu    = var.pod_resource_config["micro"].requests.cpu
                  memory = var.pod_resource_config["micro"].requests.memory
                }
                limits = {
                  cpu    = var.pod_resource_config["micro"].limits.cpu
                  memory = var.pod_resource_config["micro"].limits.memory
                }
              }

              # Env variables
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
                value = "true"
              }
              env {
                name  = "CACHE_REDIS_CLUSTER_RUN_IN_DOCKER"
                value = "false"
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

              env {
                name  = "S3_DIGITALOCEAN1_ENDPOINT"
                value = var.s3_digitalocean1_endpoint
              }
              env {
                name  = "S3_DIGITALOCEAN1_ACCESS_KEY_ID"
                value = var.s3_digitalocean1_access_key_id
              }
              env {
                name  = "S3_DIGITALOCEAN1_SECRET_ACCESS_KEY"
                value = var.s3_digitalocean1_secret_access_key
              }
              env {
                name  = "S3_DIGITALOCEAN1_REGION"
                value = var.s3_digitalocean1_region
              }
              env {
                name  = "S3_DIGITALOCEAN1_BUCKET_NAME"
                value = var.s3_digitalocean1_bucket_name
              }

              env {
                name  = "CIPHER_SECRET"
                value = var.cipher_secret
              }
              env {
                name  = "GOOGLE_CLOUD_DRIVER_CLIENT_EMAIL"
                value = var.google_cloud_driver_client_email
              }
              env {
                name  = "GOOGLE_CLOUD_DRIVER_PRIVATE_KEY"
                value = var.google_cloud_driver_private_key
              }
              env {
                name  = "GOOGLE_CLOUD_DRIVER_FOLDER_ID"
                value = var.google_cloud_driver_folder_id
              }
              env {
                name  = "GOOGLE_CLOUD_OAUTH_CLIENT_ID"
                value = var.google_cloud_oauth_client_id
              }
              env {
                name  = "GOOGLE_CLOUD_OAUTH_CLIENT_SECRET"
                value = var.google_cloud_oauth_client_secret
              }
              env {
                name  = "GOOGLE_CLOUD_OAUTH_REDIRECT_URI"
                value = var.google_cloud_oauth_redirect_uri
              }
              env {
                name  = "BACKUP_DIR"
                value = "/etc/backups"
              }
            }
          }
        }
        backoff_limit = 3
      }
    }
  }

  depends_on = [
    helm_release.gameplay_mongodb
  ]
}

resource "kubernetes_job" "instant_backup_db" {
  metadata {
    name      = "instant-backup-db"
    namespace = kubernetes_namespace.jobs.metadata[0].name
  }
  spec {
    template {
      metadata {}
      spec {
        image_pull_secrets {
          name = kubernetes_secret.docker_credentials.metadata[0].name
        }
        volume {
          name = "backup-volume"
          empty_dir {} # temporary storage for job
        }
        container {
          volume_mount {
            name       = "backup-volume"
            mount_path = "/etc/backups"
          }
          name    = "instant-backup-db"
          image   = local.cli.image
          command = ["cifarm", "db", "backup"]
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
          env {
            name  = "S3_DIGITALOCEAN1_ENDPOINT"
            value = var.s3_digitalocean1_endpoint
          }
          env {
            name  = "S3_DIGITALOCEAN1_ACCESS_KEY_ID"
            value = var.s3_digitalocean1_access_key_id
          }
          env {
            name  = "S3_DIGITALOCEAN1_SECRET_ACCESS_KEY"
            value = var.s3_digitalocean1_secret_access_key
          }
          env {
            name  = "S3_DIGITALOCEAN1_REGION"
            value = var.s3_digitalocean1_region
          }
          env {
            name  = "S3_DIGITALOCEAN1_BUCKET_NAME"
            value = var.s3_digitalocean1_bucket_name
          }
          env {
            name  = "CIPHER_SECRET"
            value = var.cipher_secret
          }
          env {
            name  = "GOOGLE_CLOUD_DRIVER_CLIENT_EMAIL"
            value = var.google_cloud_driver_client_email
          }
          env {
            name  = "GOOGLE_CLOUD_DRIVER_PRIVATE_KEY"
            value = var.google_cloud_driver_private_key
          }
          env {
            name  = "GOOGLE_CLOUD_DRIVER_FOLDER_ID"
            value = var.google_cloud_driver_folder_id
          }
          env {
            name  = "GOOGLE_CLOUD_OAUTH_CLIENT_ID"
            value = var.google_cloud_oauth_client_id
          }
          env {
            name  = "GOOGLE_CLOUD_OAUTH_CLIENT_SECRET"
            value = var.google_cloud_oauth_client_secret
          }
          env {
            name  = "GOOGLE_CLOUD_OAUTH_REDIRECT_URI"
            value = var.google_cloud_oauth_redirect_uri
          }
          env {
            name  = "BACKUP_DIR"
            value = "/etc/backups"
          }
        }
      }
    }
    backoff_limit = 3
  }
  wait_for_completion = true
  timeouts {
    create = "1h"
    update = "1h"
  }
  depends_on = [
    helm_release.gameplay_mongodb
  ]
}