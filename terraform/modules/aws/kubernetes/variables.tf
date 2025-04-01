// AWS credentials
# Region where AWS resources will be deployed.
# The `region` variable is used to specify the AWS region for the resources.
variable "region" {
  type        = string
  default     = "ap-southeast-1" # Default region is set to "ap-southeast-1" (Singapore)
  description = "AWS region"     # Description to specify that this is the region for deployment
}

# AWS access key for programmatic access to AWS.
# The `access_key` variable holds the AWS access key that provides access to AWS services.
# This key is sensitive and should not be exposed in logs or outputs.
variable "access_key" {
  type        = string
  description = "AWS access key" # Description clarifying that this is the AWS access key
  sensitive   = true             # Marks this variable as sensitive to prevent it from being displayed in logs
}

# AWS secret key corresponding to the access key.
# The `secret_key` variable holds the AWS secret key that complements the access key and provides secure access.
# This key is sensitive and should be handled securely.
variable "secret_key" {
  type        = string
  description = "AWS secret key" # Description clarifying that this is the AWS secret key
  sensitive   = true             # Marks this variable as sensitive to prevent it from being displayed in logs
}

# Name of the EKS cluster to be created.
# The `cluster_name` variable is used to specify the name of the EKS cluster that will be created.
variable "cluster_name" {
  type        = string                    # Specifies that this variable is of type string
  description = "Name of the EKS cluster" # Description to specify that this variable holds the name of the EKS cluster
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

# EBS volume base name configuration
# This defines the base name for any EBS volumes created in the infrastructure. 
variable "ebs_volume_base_name" {
  type        = string                         # The variable type is string, as it stores the base name for EBS volumes
  description = "Base name for the EBS volume" # Provides a description for the base name of the volume
  default     = "ebs"                          # The default value is "ebs", but it can be overridden by providing a different value
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
variable "primary_node_group_name" {
  type        = string                    # Specifies that the value of this variable will be a string.
  description = "Primary node group name" # Describes the purpose of the variable as the primary node group name.
}

# Variable for the secondary node group name in an EKS cluster.
# This is used to define the name of the secondary node group that will be created.
variable "secondary_node_group_name" {
  type        = string                      # Specifies that the value of this variable will be a string.
  description = "Secondary node group name" # Describes the purpose of the variable as the secondary node group name.
}

variable "cluster_autoscaler_iam_role_arn" {
  type        = string                                    # Specifies that the value of this variable will be a string.
  description = "IAM role ARN for the Cluster Autoscaler" # Describes the purpose of the variable as the IAM role ARN for the Cluster Autoscaler.
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
  default     = "eks"
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

# def requestCpu = "${request_cpu}"
# def requestMemory = "${request_memory}"
# def limitCpu = "${limit_cpu}"
# def limitMemory = "${limit_memory}"
# def nodeSelector = "${node_selector}"
# def namespace = "${namespace}"

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

# // templates
# def requestCpu = "${request_cpu}"
# def requestMemory = "${request_memory}"
# def limitCpu = "${limit_cpu}"
# def limitMemory = "${limit_memory}"
# def nodeSelector = "${node_selector}"
# def namespace = "${namespace}"

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
        cpu               = "30m"
        memory            = "60Mi"
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "90m"
        memory            = "180Mi"
        ephemeral_storage = "2Gi"
      }
    }
    micro = {
      requests = {
        cpu               = "45m"  # 1.5 times nano
        memory            = "90Mi" # 1.5 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "135m"  # 1.5 times nano
        memory            = "270Mi" # 1.5 times nano
        ephemeral_storage = "2Gi"
      }
    }
    small = {
      requests = {
        cpu               = "60m"   # 2 times nano
        memory            = "120Mi" # 2 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "180m"  # 2 times nano
        memory            = "360Mi" # 2 times nano
        ephemeral_storage = "2Gi"
      }
    }
    medium = {
      requests = {
        cpu               = "90m"   # 3 times nano
        memory            = "180Mi" # 3 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "270m"  # 3 times nano
        memory            = "540Mi" # 3 times nano
        ephemeral_storage = "2Gi"
      }
    }
    large = {
      requests = {
        cpu               = "150m"  # 5 times nano
        memory            = "300Mi" # 5 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "300m"  # 20 times nano
        memory            = "900Mi" # 20 times nano
        ephemeral_storage = "2Gi"
      }
    }
    xlarge = {
      requests = {
        cpu               = "600m"   # 20 times nano
        memory            = "1200Mi" # 20 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "1800m"  # 20 times nano
        memory            = "3600Mi" # 20 times nano
        ephemeral_storage = "2Gi"
      }
    }
    "2xlarge" = {
      requests = {
        cpu               = "2700m"  # 30 times nano
        memory            = "5400Mi" # 30 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "5400m"   # 30 times nano
        memory            = "10800Mi" # 30 times nano
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
  default = "https://www.cifarm.xyz"
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
