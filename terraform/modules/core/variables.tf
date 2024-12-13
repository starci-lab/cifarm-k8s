### Databases
# PostgreSQL database
variable "gameplay_postgres_database" {
  description = "The Gameplay PostgreSQL database name"
  type        = string
  sensitive   = true
}

# PostgreSQL password
variable "gameplay_postgres_password" {
  description = "The Gameplay PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "ebs_volume_base_name" {
  type        = string
  description = "Base name for the EBS volume"
  default     = "ebs"
}

variable "bitnami_repository" {
  type        = string
  description = "Bitnami Helm repository"
  default     = "oci://registry-1.docker.io/bitnamicharts"
}

variable "grafana_user" {
  type        = string
  description = "Grafana user"
  sensitive = true
}

variable "grafana_password" {
  type        = string
  description = "Grafana password"
  sensitive = true
}

variable "grafana_prometheus_url" {
  type = string
  description = "Prometheus URL for Grafana"
  default = "https://prometheus.staging.cifarm.starci.net"
}

variable "grafana_prometheus_alertmanager_url" {
  type = string
  description = "Prometheus Alertmanager URL for Grafana"
  default = "https://prometheus-alertmanager.staging.cifarm.starci.net"
}