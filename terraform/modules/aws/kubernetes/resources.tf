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
        cpu               = "75m"   # 2.5 times nano
        memory            = "150Mi" # 2.5 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "225m"  # 2.5 times nano
        memory            = "450Mi" # 2.5 times nano
        ephemeral_storage = "2Gi"
      }
    }
    small = {
      requests = {
        cpu               = "150m"  # 5 times nano
        memory            = "300Mi" # 5 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "450m"  # 5 times nano
        memory            = "900Mi" # 5 times nano
        ephemeral_storage = "2Gi"
      }
    }
    medium = {
      requests = {
        cpu               = "300m"  # 10 times nano
        memory            = "600Mi" # 10 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "900m"   # 10 times nano
        memory            = "1800Mi" # 10 times nano
        ephemeral_storage = "2Gi"
      }
    }
    large = {
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
    xlarge = {
      requests = {
        cpu               = "900m"   # 30 times nano
        memory            = "1800Mi" # 30 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "2700m"  # 30 times nano
        memory            = "5400Mi" # 30 times nano
        ephemeral_storage = "2Gi"
      }
    }
    "2xlarge" = {
      requests = {
        cpu               = "1800m"  # 60 times nano
        memory            = "3600Mi" # 60 times nano
        ephemeral_storage = "50Mi"
      }
      limits = {
        cpu               = "5400m"   # 60 times nano
        memory            = "10800Mi" # 60 times nano
        ephemeral_storage = "2Gi"
      }
    }
  }
}