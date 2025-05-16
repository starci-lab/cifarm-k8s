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
  default     = "1.32.2-do.1"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "primary_node_pool_name" {
  type        = string
  description = "Primary node pool name"
}

variable "primary_node_count" {
  type        = number
  description = "Primary node count"
}

variable "primary_node_size" {
  type        = string
  description = "Primary node size"
}

variable "primary_node_auto_scale" {
  type        = bool
  description = "Primary node auto scale"
}


