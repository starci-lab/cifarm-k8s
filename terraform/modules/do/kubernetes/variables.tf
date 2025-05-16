# DigitalOcean token
variable "do_token" {
  type        = string
  description = "DigitalOcean token" # Description to specify that this is the region for deployment
  sensitive   = true
}

# region
variable "region" {
  type        = string
  description = "Region"
  default     = "sgp1"
}

# cluster version
variable "cluster_version" {
  type        = string
  description = "Cluster version"
  default     = "1.32.2-do.0"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

##################################################
# Base configuration for the EKS cluster

# Grafana user configuration
# Stores the Grafana user credentials for logging into the Grafana dashboard.
variable "grafana_user" {
  type        = string         # The variable type is string, storing the username for Grafana login
  description = "Grafana user" # Describes the user variable for Grafana access
  sensitive   = true           # The username is marked as sensitive to avoid exposure
}

# Grafana password configuration
# Stores the Grafana password for the user specified in the previous variable.
variable "grafana_password" {
  type        = string             # The variable type is string, as it stores the password
  description = "Grafana password" # Describes the password variable for Grafana access
  sensitive   = true               # The password is marked as sensitive to protect security
}

# Bitnami Helm repository configuration
# This variable stores the URL of the Bitnami Helm repository. It is used for chart installation via Helm.
variable "bitnami_repository" {
  type        = string                                     # The type is string since the repository URL is a string value
  description = "Bitnami Helm repository"                  # Describes the URL to the Bitnami Helm chart repository
  default     = "oci://registry-1.docker.io/bitnamicharts" # Default repository URL for Bitnami charts
}

variable "portainer_repository" {
  type        = string                             # The type is string for the Portainer repository
  description = "Portainer repository"             # Describes the Portainer repository
  default     = "https://portainer.github.io/k8s/" # Default URL for the Portainer repository
}

variable "keda_repository" {
  type        = string                               # The type is string for the Keda repository
  description = "Keda repository"                    # Describes the Keda repository
  default     = "https://kedacore.github.io/charts/" # Default URL for the Keda repository
}

variable "cluster_autoscaler_repository" {
  type        = string                                    # The type is string for the cluster autoscaler repository
  description = "Cluster autoscaler repository"           # Describes the cluster autoscaler repository
  default     = "https://kubernetes.github.io/autoscaler" # Default URL for the cluster autoscaler repository
}

variable "container_repository" {
  type        = string                 # The type is string for the container repository
  description = "Container repository" # Describes the container repository
  default     = "https://starci-lab.github.io/cifarm-k8s/charts"
}

variable "system_namespace" {
  type        = string                                      # The type is string for the system namespace
  description = "System namespace for Kubernetes resources" # Describes the system namespace for Kubernetes resources
  default     = "kube-system"                               # Default system namespace is "kube-system"
}

# Grafana Prometheus URL configuration
# The Prometheus URL used by Grafana for monitoring purposes. This is the endpoint from which Grafana fetches metrics.
variable "grafana_prometheus_url" {
  type        = string                                         # The type is string because the URL is a string
  description = "Prometheus URL for Grafana"                   # Describes the Prometheus URL used by Grafana for monitoring
  default     = "https://prometheus.staging.cifarm.starci.net" # Default Prometheus URL for staging environment
}

# Grafana Prometheus Alertmanager URL configuration
# This variable stores the URL of the Prometheus Alertmanager, which sends alerts to Grafana when thresholds are reached.
variable "grafana_prometheus_alertmanager_url" {
  type        = string                                                      # The type is string for the Alertmanager URL
  description = "Prometheus Alertmanager URL for Grafana"                   # Describes the Alertmanager URL for Grafana
  default     = "https://prometheus-alertmanager.staging.cifarm.starci.net" # Default URL for Alertmanager
}

# Variable for the primary node group name in an EKS cluster.
# This is used to define the name of the primary node group that will be created.
variable "primary_node_pool_name" {
  type        = string                   # Specifies that the value of this variable will be a string.
  description = "Primary node pool name" # Describes the purpose of the variable as the primary node group name.
}

variable "jwt_secret" {
  type        = string # Specifies that the value of this variable will be a string.
  description = "JWT secret"
  sensitive   = true # Marks the JWT secret as sensitive to avoid exposure in logs
}

variable "jwt_access_token_expiration" {
  type        = string # Specifies that the value of this variable will be a string.
  description = "JWT access token expiration"
  default     = "3m" # Default expiration time for JWT access tokens
}

variable "jwt_refresh_token_expiration" {
  type        = string # Specifies that the value of this variable will be a string.
  description = "JWT refresh token expiration"
  default     = "7d" # Default expiration time for JWT refresh tokens
}

variable "jenkins_user" {
  type        = string         # Specifies that the value of this variable will be a string.
  description = "Jenkins user" # Describes the purpose of the variable as the Jenkins user.
  sensitive   = true           # Marks the Jenkins user as sensitive to avoid exposure in logs
}

variable "jenkins_password" {
  type        = string             # Specifies that the value of this variable will be a string.
  description = "Jenkins password" # Describes the purpose of the variable as the Jenkins password.
  sensitive   = true               # Marks the Jenkins password as sensitive to avoid exposure in logs
}

variable "email" {
  type        = string
  description = "Email address for notifications"
  default     = "cuongnvtse160875@gmail.com"
}

variable "cluster_issuer_name" {
  type        = string
  description = "The name of the ClusterIssuer to use for cert-manager"
  default     = "letsencrypt-prod"
}

variable "base_domain_name" {
  type        = string
  description = "The base domain name used"
  default     = "cifarm.xyz"
}

variable "subdomain_prefix" {
  type        = string
  description = "The subdomain prefix used"
  default     = "doks"
}

variable "cloudflare_api_token" {
  type        = string
  description = "API token for Cloudflare"
  sensitive   = true
}

variable "build_branch" {
  type        = string
  description = "Branch to build"
  default     = "build"
}

variable "containers_git_repository" {
  type        = string
  description = "Git repository for containers"
  default     = "https://github.com/starci-lab/cifarm-containers.git"
}


variable "jenkins_github_access_token" {
  type        = string
  description = "Github secret for Jenkins"
  sensitive   = true
}

variable "jenkins_github_hook_secret" {
  type        = string
  description = "Github hook secret for Jenkins"
  sensitive   = true
}

# Docker credentials for pushing images to Dockerhub
variable "docker_username" {
  type        = string
  description = "Docker username"
  default     = "cifarm"
}

variable "docker_password" {
  type        = string
  description = "Docker password"
  sensitive   = true
}

variable "docker_email" {
  type        = string
  description = "Docker email"
  default     = "cifarm.starcilab@gmail.com"
}

variable "docker_registry" {
  type        = string
  description = "Docker registry"
  default     = "https://index.docker.io/v1/"
}

variable "jenkins_agent_request_cpu" {
  type        = string
  description = "Jenkins agent request CPU"
  default     = "180m"
}

variable "solana_honeycomb_authority_private_key_mainnet" {
  type        = string
  description = "Solana Honeycomb authority private key for mainnet"
  sensitive   = true
}

variable "solana_honeycomb_authority_private_key_testnet" {
  type        = string
  description = "Solana Honeycomb authority private key for testnet"
  sensitive   = true
}

variable "pod_resource_config" {
  description = "Pod resource configurations for different sizes"
  type = map(object({
    requests = object({
      cpu               = string
      memory            = string
      ephemeral_storage = string
    })
    limits = object({
      cpu               = string
      memory            = string
      ephemeral_storage = string
    })
  }))
  default = {
    nano = {
      requests = {
        cpu               = "25m"
        memory            = "50Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "75m"
        memory            = "150Mi"
        ephemeral_storage = "2Gi"
      }
    }
    micro = {
      requests = {
        cpu               = "38m"  # 1.5 * 25
        memory            = "75Mi" # 1.5 * 50
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "113m"  # 1.5 * 75
        memory            = "225Mi" # 1.5 * 150
        ephemeral_storage = "2Gi"
      }
    }
    small = {
      requests = {
        cpu               = "50m"   # 2 * 25
        memory            = "100Mi" # 2 * 50
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "150m"  # 2 * 75
        memory            = "300Mi" # 2 * 150
        ephemeral_storage = "2Gi"
      }
    }
    medium = {
      requests = {
        cpu               = "75m"   # 3 * 25
        memory            = "150Mi" # 3 * 50
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "225m"  # 3 * 75
        memory            = "450Mi" # 3 * 150
        ephemeral_storage = "2Gi"
      }
    }
    large = {
      requests = {
        cpu               = "100m"  # 5 * 25
        memory            = "200Mi" # 5 * 50
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "300m"   # 20 * 25
        memory            = "600Mi" # 20 * 50
        ephemeral_storage = "2Gi"
      }
    }
    xlarge = {
      requests = {
        cpu               = "300m"   # 20 * 25
        memory            = "600Mi" # 20 * 50
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "900m"  # 20 * 75
        memory            = "1800Mi" # 20 * 150
        ephemeral_storage = "2Gi"
      }
    }
    "2xlarge" = {
      requests = {
        cpu               = "450m"   # 30 * 25
        memory            = "900Mi" # 30 * 50
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "1350m"  # 30 * 75
        memory            = "2700Mi" # 30 * 150
        ephemeral_storage = "2Gi"
      }
    }
  }
}

variable "socket_io_admin_username" {
  type        = string
  description = "Socket.IO admin username"
  sensitive   = true
}

variable "socket_io_admin_password" {
  type        = string
  description = "Socket.IO admin password"
  sensitive   = true
}

variable "jenkins_container_cap" {
  type        = number
  description = "Jenkins container capacity"
  default     = 2
}

variable "cache_redis_password" {
  type        = string
  description = "Cache Redis password"
  sensitive   = true
}

variable "adapter_redis_password" {
  type        = string
  description = "Adapter Redis password"
  sensitive   = true
}

variable "job_redis_password" {
  type        = string
  description = "Job Redis password"
  sensitive   = true
}

variable "kafka_sasl_username" {
  type        = string
  description = "Kafka SASL user"
  sensitive   = true
}

variable "kafka_sasl_password" {
  type        = string
  description = "Kafka SASL password"
  sensitive   = true
}

variable "cleanup_on_fail" {
  type        = bool
  description = "Clean up on fail"
  default     = true
}

variable "adapter_mongodb_username" {
  type        = string
  description = "Adapter MongoDB username"
  default     = "root"
}

variable "adapter_mongodb_password" {
  type        = string
  description = "Adapter MongoDB password"
  sensitive   = true
}

variable "gameplay_mongodb_username" {
  type        = string
  description = "Gameplay MongoDB username"
  default     = "root"
}

variable "gameplay_mongodb_auth_replica_set_key" {
  type        = string
  description = "Gameplay MongoDB auth replica set key"
  sensitive   = true
}

variable "gameplay_mongodb_password" {
  type        = string
  description = "Gameplay MongoDB password"
  sensitive   = true
}

variable "postgresql_max_connections" {
  type        = number
  description = "PostgreSQL maximum connections"
  default     = 500
}

variable "pgpool_reserved_connections" {
  type        = number
  description = "PGPool reserved connections"
  default     = 0
}

variable "pgpool_max_pool" {
  type        = number
  description = "PGPool maximum pool"
  default     = 50
}

variable "pgpool_child_max_connections" {
  type        = number
  description = "PGPool child maximum connections"
  default     = 1000
}

variable "pgpool_num_init_children" {
  type        = number
  description = "PGPool number of initial child processes"
  default     = 100
}

variable "telegram_bot_token" {
  type        = string
  description = "Telegram bot token"
  sensitive   = true
}

variable "telegram_miniapp_url" {
  type        = string
  description = "Telegram miniapp URL"
  default     = "https://www.cifarm.xyz"
}

variable "ws_allow_origin_1" {
  type        = string
  description = "WebSocket allow origin 1"
  default     = "https://cifarm.xyz"
}

variable "ws_allow_origin_2" {
  type        = string
  description = "WebSocket allow origin 2"
  default     = "https://ws-admin.eks.cifarm.xyz"
}

variable "graphql_allow_origin_1" {
  type        = string
  description = "GraphQL allow origin 1"
  default     = "https://cifarm.xyz"
}

variable "solana_metaplex_authority_private_key_mainnet" {
  type        = string
  description = "Solana Metaplex authority private key for mainnet"
  sensitive   = true
}

variable "solana_metaplex_authority_private_key_testnet" {
  type        = string
  description = "Solana Metaplex authority private key for testnet"
  sensitive   = true
}

variable "farcaster_signer_uuid" {
  type        = string
  description = "Farcaster signer UUID"
  sensitive   = true
}

variable "farcaster_api_key" {
  type        = string
  description = "Farcaster API key"
  sensitive   = true
}

variable "gameplay_mongodb_persistence_size" {
  type        = string
  description = "Gameplay MongoDB persistence size"
  default     = "4Gi"
}

variable "adapter_redis_persistence_size" {
  type        = string
  description = "Adapter Redis persistence size"
  default     = "1Gi"
}

variable "cache_redis_persistence_size" {
  type        = string
  description = "Cache Redis persistence size"
  default     = "1Gi"
}

variable "job_redis_persistence_size" {
  type        = string
  description = "Job Redis persistence size"
  default     = "1Gi"
}

variable "kafka_persistence_size" {
  type        = string
  description = "Kafka persistence size"
  default     = "2Gi"
}

variable "s3_digitalocean1_endpoint" {
  type        = string
  description = "DigitalOcean Spaces endpoint"
  sensitive   = true
}

variable "s3_digitalocean1_access_key_id" {
  type        = string
  description = "DigitalOcean Spaces access key ID"
  sensitive   = true
}

variable "s3_digitalocean1_secret_access_key" {
  type        = string
  description = "DigitalOcean Spaces secret access key"
  sensitive   = true
}

variable "s3_digitalocean1_region" {
  type        = string
  description = "DigitalOcean Spaces region"
  default     = "sgp1"
}

variable "s3_digitalocean1_bucket_name" {
  type        = string
  description = "DigitalOcean Spaces bucket name"
  default     = "cifarm"
}

variable "solana_vault_private_key_testnet" {
  type        = string
  description = "Solana Vault private key for testnet"
  sensitive   = true
}

variable "solana_vault_private_key_mainnet" {
  type        = string
  description = "Solana Vault private key for mainnet"
  sensitive   = true
}

variable "session_secret" {
  type        = string
  description = "Session secret"
  sensitive   = true
}

variable "cipher_secret" {
  type        = string
  description = "Cipher secret"
  sensitive   = true
}

variable "web_app_url_mainnet" {
  type        = string
  description = "Web app URL for mainnet"
  default     = "https://cifarm.xyz"
}

variable "web_app_url_testnet" {
  type        = string
  description = "Web app URL for testnet"
  default     = "https://testnet.cifarm.xyz"
}

variable "google_cloud_oauth_client_id" {
  type        = string
  description = "Google Cloud OAuth client ID"
  sensitive   = true
}

variable "google_cloud_oauth_client_secret" {
  type        = string
  description = "Google Cloud OAuth client secret"
  sensitive   = true
}

variable "google_cloud_oauth_redirect_uri" {
  type        = string
  description = "Google Cloud OAuth redirect URI"
  default     = "https://auth.cifarm.xyz/auth/google/callback"
}

variable "x_oauth_client_id" {
  type        = string
  description = "X OAuth client ID"
  sensitive   = true
}

variable "x_oauth_client_secret" {
  type        = string
  description = "X OAuth client secret"
  sensitive   = true
}

variable "x_oauth_redirect_uri" {
  type        = string
  description = "X OAuth redirect URI"
  default     = "https://auth.cifarm.xyz/auth/x/callback"
}

variable "facebook_oauth_client_id" {
  type        = string
  description = "Facebook OAuth client ID"
  sensitive   = true
}

variable "facebook_oauth_client_secret" {
  type        = string
  description = "Facebook OAuth client secret"
  sensitive   = true
}

variable "facebook_oauth_redirect_uri" {
  type        = string
  description = "Facebook OAuth redirect URI"
  default     = "https://auth.cifarm.xyz/auth/facebook/callback"
}







