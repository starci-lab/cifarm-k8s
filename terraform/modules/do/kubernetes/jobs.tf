# define common env variables
locals {
  common_env = {
    GAMEPLAY_MONGODB_DBNAME                        = local.gameplay_mongodb.database
    GAMEPLAY_MONGODB_HOST                          = local.gameplay_mongodb.host
    GAMEPLAY_MONGODB_PORT                          = local.gameplay_mongodb.port
    GAMEPLAY_MONGODB_USERNAME                      = var.gameplay_mongodb_username
    GAMEPLAY_MONGODB_PASSWORD                      = var.gameplay_mongodb_password
    CACHE_REDIS_HOST                               = local.cache_redis.host
    CACHE_REDIS_PORT                               = local.cache_redis.port
    CACHE_REDIS_PASSWORD                           = var.cache_redis_password
    CACHE_REDIS_CLUSTER_ENABLED                    = "true"
    CACHE_REDIS_CLUSTER_RUN_IN_DOCKER              = "false"
    SOLANA_HONEYCOMB_AUTHORITY_PRIVATE_KEY_MAINNET = var.solana_honeycomb_authority_private_key_mainnet
    SOLANA_HONEYCOMB_AUTHORITY_PRIVATE_KEY_TESTNET = var.solana_honeycomb_authority_private_key_testnet
    SOLANA_METAPLEX_AUTHORITY_PRIVATE_KEY_MAINNET  = var.solana_metaplex_authority_private_key_mainnet
    SOLANA_METAPLEX_AUTHORITY_PRIVATE_KEY_TESTNET  = var.solana_metaplex_authority_private_key_testnet
    FARCASTER_SIGNER_UUID                          = var.farcaster_signer_uuid
    FARCASTER_API_KEY                              = var.farcaster_api_key
    S3_DIGITALOCEAN1_ENDPOINT                      = var.s3_digitalocean1_endpoint
    S3_DIGITALOCEAN1_ACCESS_KEY_ID                 = var.s3_digitalocean1_access_key_id
    S3_DIGITALOCEAN1_SECRET_ACCESS_KEY             = var.s3_digitalocean1_secret_access_key
    S3_DIGITALOCEAN1_REGION                        = var.s3_digitalocean1_region
    S3_DIGITALOCEAN1_BUCKET_NAME                   = var.s3_digitalocean1_bucket_name
    CIPHER_SECRET                                  = var.cipher_secret
    GOOGLE_CLOUD_DRIVER_CLIENT_EMAIL               = var.google_cloud_driver_client_email
    GOOGLE_CLOUD_DRIVER_PRIVATE_KEY                = var.google_cloud_driver_private_key
    GOOGLE_CLOUD_DRIVER_FOLDER_ID                  = var.google_cloud_driver_folder_id
    GOOGLE_CLOUD_OAUTH_CLIENT_ID                   = var.google_cloud_oauth_client_id
    GOOGLE_CLOUD_OAUTH_CLIENT_SECRET               = var.google_cloud_oauth_client_secret
    GOOGLE_CLOUD_OAUTH_REDIRECT_URI                = var.google_cloud_oauth_redirect_uri
    BACKUP_DIR                                     = "/etc/backups"
  }
}

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

          dynamic "env" {
            for_each = local.common_env
            content {
              name  = env.key
              value = env.value
            }
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

resource "kubernetes_job" "sanitize_usernames" {
  metadata {
    name      = "sanitize-username"
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
          name    = "sanitize-usernames"
          image   = local.cli.image
          command = ["cifarm", "db", "sanitize-usernames"]
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

          dynamic "env" {
            for_each = local.common_env
            content {
              name  = env.key
              value = env.value
            }
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

              dynamic "env" {
                for_each = local.common_env
                content {
                  name  = env.key
                  value = env.value
                }
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
