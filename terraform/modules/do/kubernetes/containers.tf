# Create namespace for the databases
resource "kubernetes_namespace" "containers" {
  metadata {
    name = "containers"
  }
}

locals {
  client = {
    name = "client"
    host = "client-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
    port = 3000
  }

  // Gameplay Service
  gameplay_service = {
    name              = "gameplay-service"
    port              = 8080
    health_check_port = 8081
    host              = "gameplay-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // Rest API Gateway
  rest_api_gateway = {
    name              = "rest-api-gateway"
    port              = 8080
    health_check_port = 8081
    host              = "rest-api-gateway-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // Gameplay Subgraph
  gameplay_subgraph = {
    name              = "gameplay-subgraph"
    port              = 8080
    health_check_port = 8081
    host              = "gameplay-subgraph-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // GraphQL Maingraph
  graphql_gateway = {
    name              = "graphql-gateway"
    port              = 8080
    health_check_port = 8081
    host              = "graphql-gateway-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  // IO Gameplay
  ws = {
    name              = "ws"
    port              = 8080
    health_check_port = 8081
    host              = "ws-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
    admin_ui_port     = 8082
  }

  cron_scheduler = {
    name              = "cron-scheduler"
    health_check_port = 8081
    host              = "cron-scheduler-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  cron_worker = {
    name              = "cron-worker"
    health_check_port = 8081
    host              = "cron-worker-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
  }

  telegram_bot = {
    name              = "telegram-bot"
    host              = "telegram-bot-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
    health_check_port = 8081
  }

  social_auth = {
    name              = "social-auth"
    host              = "social-auth-service.${kubernetes_namespace.containers.metadata[0].name}.svc.cluster.local"
    port              = 8080
    health_check_port = 8081
  }
}

resource "helm_release" "gameplay_subgraph" {
  name            = local.gameplay_subgraph.name
  repository      = var.container_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "service"
  namespace       = kubernetes_namespace.containers.metadata[0].name
  
  values = [
    templatefile("${path.module}/manifests/gameplay-subgraph-values.yaml", {
      node_pool_label = var.primary_node_pool_name,
      // Gameplay Mongodb Configuration
      gameplay_mongodb_host     = local.gameplay_mongodb.host,
      gameplay_mongodb_database = local.gameplay_mongodb.database,
      gameplay_mongodb_password = var.gameplay_mongodb_password,
      gameplay_mongodb_username = var.gameplay_mongodb_username,
      gameplay_mongodb_port     = local.gameplay_mongodb.port,
      // Gameplay Service Configuration
      port              = local.gameplay_subgraph.port,
      health_check_port = local.gameplay_subgraph.health_check_port,
      // Cache Redis Configuration
      cache_redis_host            = local.cache_redis.host,
      cache_redis_port            = local.cache_redis.port,
      cache_redis_cluster_enabled = true,
      cache_redis_password        = var.cache_redis_password,

      jwt_secret = var.jwt_secret,

      // Kafka Configuration
      kafka_host          = local.kafka.host,
      kafka_port          = local.kafka.port,
      kafka_sasl_enabled  = true,
      kafka_sasl_username = var.kafka_sasl_username,
      kafka_sasl_password = var.kafka_sasl_password,
      // Honeycomb Configuration
      solana_honeycomb_authority_private_key_mainnet = var.solana_honeycomb_authority_private_key_mainnet,
      solana_honeycomb_authority_private_key_testnet = var.solana_honeycomb_authority_private_key_testnet,
      // Metaplex Configuration
      solana_metaplex_authority_private_key_mainnet = var.solana_metaplex_authority_private_key_mainnet,
      solana_metaplex_authority_private_key_testnet = var.solana_metaplex_authority_private_key_testnet,
      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,

      // DigitalOcean Spaces Configuration
      s3_digitalocean1_endpoint = var.s3_digitalocean1_endpoint,
      s3_digitalocean1_access_key_id = var.s3_digitalocean1_access_key_id,
      s3_digitalocean1_secret_access_key = var.s3_digitalocean1_secret_access_key,
      s3_digitalocean1_region = var.s3_digitalocean1_region,
      s3_digitalocean1_bucket_name = var.s3_digitalocean1_bucket_name,

      // Solana Vault Configuration
      solana_vault_private_key_testnet = var.solana_vault_private_key_testnet,
      solana_vault_private_key_mainnet = var.solana_vault_private_key_mainnet,
    
      // Cipher Secret
      cipher_secret = var.cipher_secret,
    })
  ]

  dynamic "set" {
    for_each = local.set_pull_secrets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  depends_on = [
    # helm_release.keda,
    helm_release.cache_redis,
    helm_release.gameplay_mongodb,
    kubernetes_job.seed_db,
  ]
}

resource "helm_release" "graphql_gateway" {
  name            = local.graphql_gateway.name
  repository      = var.container_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "service"
  namespace       = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/graphql-gateway-values.yaml", {
      node_pool_label = var.primary_node_pool_name,

      // Gameplay Service Configuration
      gameplay_subgraph_host              = local.gameplay_subgraph.host,
      gameplay_subgraph_port              = local.gameplay_subgraph.port,
      gameplay_subgraph_health_check_port = local.gameplay_subgraph.health_check_port,

      // Jwt
      jwt_secret        = var.jwt_secret,
      port              = local.graphql_gateway.port,
      health_check_port = local.graphql_gateway.health_check_port,

      // Cache Redis Configuration
      cache_redis_host            = local.cache_redis.host,
      cache_redis_port            = local.cache_redis.port,
      cache_redis_password        = var.cache_redis_password,
      cache_redis_cluster_enabled = true,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,

      allow_origin_1 = var.graphql_allow_origin_1,

      // Cipher Secret
      cipher_secret = var.cipher_secret,
    })
  ]

  dynamic "set" {
    for_each = local.set_pull_secrets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  depends_on = [
    # helm_release.keda,
    helm_release.gameplay_subgraph,
    kubernetes_job.seed_db,
  ]
}

resource "helm_release" "ws" {
  name            = local.ws.name
  repository      = var.container_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "service"
  namespace       = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/ws-values.yaml", {
      node_pool_label = var.primary_node_pool_name,

      // Gameplay Mongodb Configuration
      gameplay_mongodb_host     = local.gameplay_mongodb.host,
      gameplay_mongodb_database = local.gameplay_mongodb.database,
      gameplay_mongodb_password = var.gameplay_mongodb_password,
      gameplay_mongodb_username = var.gameplay_mongodb_username,
      gameplay_mongodb_port     = local.gameplay_mongodb.port,

      // Gameplay Service Configuration
      port              = local.ws.port,
      health_check_port = local.ws.health_check_port,

      production_url  = local.ws_admin_domain_name,
      cluster_enabled = false,
      adapter         = "redis-stream",

      admin_username = var.socket_io_admin_username,
      admin_password = var.socket_io_admin_password,
      admin_ui_port  = local.ws.admin_ui_port,

      // Cache Redis Configuration
      cache_redis_host            = local.cache_redis.host,
      cache_redis_port            = local.cache_redis.port,
      cache_redis_password        = var.cache_redis_password,
      cache_redis_cluster_enabled = true,

      // Adapter Redis Configuration
      adapter_redis_host            = local.adapter_redis.host,
      adapter_redis_port            = local.adapter_redis.port,
      adapter_redis_password        = var.adapter_redis_password,
      adapter_redis_cluster_enabled = true,

      # adapter_mongodb_host     = local.adapter_mongodb.host,
      # adapter_mongodb_port     = local.adapter_mongodb.port,
      # adapter_mongodb_username = var.adapter_mongodb_username,
      # adapter_mongodb_password = var.adapter_mongodb_password,
      # adapter_mongodb_dbname   = local.adapter_mongodb.database,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,

      // Kafka Configuration
      kafka_host          = local.kafka.host,
      kafka_port          = local.kafka.port,
      kafka_sasl_enabled  = true,
      kafka_sasl_username = var.kafka_sasl_username,
      kafka_sasl_password = var.kafka_sasl_password,

      allow_origin_1 = var.ws_allow_origin_1,
      allow_origin_2 = var.ws_allow_origin_2,

      // Jwt
      jwt_secret = var.jwt_secret,
      cipher_secret = var.cipher_secret,
    })
  ]

  dynamic "set" {
    for_each = local.set_pull_secrets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  depends_on = [
    # helm_release.keda,
    helm_release.cache_redis,
    helm_release.gameplay_mongodb,
    helm_release.kafka,
    helm_release.adapter_redis,
    kubernetes_job.seed_db
    # helm_release.adapter_redis,
  ]
}

resource "helm_release" "cron_scheduler" {
  name            = local.cron_scheduler.name
  repository      = var.container_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "service"
  namespace       = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/cron-scheduler-values.yaml", {
      node_pool_label = var.primary_node_pool_name,

      // Gameplay Mongodb Configuration
      gameplay_mongodb_host     = local.gameplay_mongodb.host,
      gameplay_mongodb_database = local.gameplay_mongodb.database,
      gameplay_mongodb_password = var.gameplay_mongodb_password,
      gameplay_mongodb_username = var.gameplay_mongodb_username,
      gameplay_mongodb_port     = local.gameplay_mongodb.port,

      // Cache Redis Configuration
      cache_redis_host            = local.cache_redis.host,
      cache_redis_port            = local.cache_redis.port,
      cache_redis_password        = var.cache_redis_password,
      cache_redis_cluster_enabled = true,

      // Job Redis Configuration
      job_redis_host            = local.job_redis.host,
      job_redis_port            = local.job_redis.port,
      job_redis_password        = var.job_redis_password,
      job_redis_cluster_enabled = true,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,

      health_check_port = local.cron_scheduler.health_check_port,

      // Kafka Configuration
      kafka_host          = local.kafka.host,
      kafka_port          = local.kafka.port,
      kafka_sasl_enabled  = true,
      kafka_sasl_username = var.kafka_sasl_username,
      kafka_sasl_password = var.kafka_sasl_password,
      
      // Cipher Secret
      cipher_secret = var.cipher_secret,
    })
  ]

  dynamic "set" {
    for_each = local.set_pull_secrets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  depends_on = [
    # helm_release.keda,
    helm_release.cache_redis,
    helm_release.gameplay_mongodb,
    helm_release.job_redis,
    kubernetes_job.seed_db,
  ]
}

resource "helm_release" "cron_worker" {
  name            = local.cron_worker.name
  repository      = var.container_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "service"
  namespace       = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/cron-worker-values.yaml", {
      node_pool_label = var.primary_node_pool_name,

      // Gameplay Mongodb Configuration
      gameplay_mongodb_host     = local.gameplay_mongodb.host,
      gameplay_mongodb_database = local.gameplay_mongodb.database,
      gameplay_mongodb_password = var.gameplay_mongodb_password,
      gameplay_mongodb_username = var.gameplay_mongodb_username,
      gameplay_mongodb_port     = local.gameplay_mongodb.port,

      // Cache Redis Configuration
      cache_redis_host            = local.cache_redis.host,
      cache_redis_port            = local.cache_redis.port,
      cache_redis_password        = var.cache_redis_password,
      cache_redis_cluster_enabled = true,

      // Job Redis Configuration
      job_redis_host            = local.job_redis.host,
      job_redis_port            = local.job_redis.port,
      job_redis_password        = var.job_redis_password,
      
      job_redis_cluster_enabled = true,

      // Kafka Configuration
      kafka_host          = local.kafka.host,
      kafka_port          = local.kafka.port,
      kafka_sasl_enabled  = true,
      kafka_sasl_username = var.kafka_sasl_username,
      kafka_sasl_password = var.kafka_sasl_password,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,

      // Cipher Secret
      cipher_secret = var.cipher_secret,

      health_check_port = local.cron_worker.health_check_port,
    })
  ]

  dynamic "set" {
    for_each = local.set_pull_secrets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  depends_on = [
    # helm_release.keda,
    helm_release.cache_redis,
    helm_release.gameplay_mongodb,
    helm_release.job_redis,
    kubernetes_job.seed_db,
  ]
}


resource "helm_release" "social_auth" {
  name            = local.social_auth.name
  repository      = var.container_repository
  cleanup_on_fail = var.cleanup_on_fail
  chart           = "service"
  namespace       = kubernetes_namespace.containers.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/social-auth-values.yaml", {
      node_pool_label = var.primary_node_pool_name,

      cipher_secret = var.cipher_secret,
      // Session Secret
      session_secret = var.session_secret,

      // Social Auth Configuration
      port = local.social_auth.port,
      health_check_port = local.social_auth.health_check_port,

      // Web App URLs
      web_app_url_mainnet = var.web_app_url_mainnet,
      web_app_url_testnet = var.web_app_url_testnet,

      // Google Cloud OAuth
      google_cloud_oauth_client_id = var.google_cloud_oauth_client_id,
      google_cloud_oauth_client_secret = var.google_cloud_oauth_client_secret,
      google_cloud_oauth_redirect_uri = var.google_cloud_oauth_redirect_uri,
      
      // X OAuth
      x_oauth_client_id = var.x_oauth_client_id,
      x_oauth_client_secret = var.x_oauth_client_secret,
      x_oauth_redirect_uri = var.x_oauth_redirect_uri,

      // Facebook OAuth 
      facebook_oauth_client_id = var.facebook_oauth_client_id,
      facebook_oauth_client_secret = var.facebook_oauth_client_secret,
      facebook_oauth_redirect_uri = var.facebook_oauth_redirect_uri,

      // Resource configurations
      request_cpu    = var.pod_resource_config["small"].requests.cpu,
      request_memory = var.pod_resource_config["small"].requests.memory,
      limit_cpu      = var.pod_resource_config["small"].limits.cpu,
      limit_memory   = var.pod_resource_config["small"].limits.memory,
    })
  ]

     dynamic "set" {
      for_each = local.set_pull_secrets
      content {
        name  = set.value.name
        value = set.value.value
      }
    }

  depends_on = [
    # helm_release.keda,
    helm_release.cache_redis,
    helm_release.gameplay_mongodb,
    helm_release.job_redis,
    kubernetes_job.seed_db,
  ]
}