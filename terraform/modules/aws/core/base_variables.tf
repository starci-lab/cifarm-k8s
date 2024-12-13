# EBS volume base name configuration
# This defines the base name for any EBS volumes created in the infrastructure. 
variable "ebs_volume_base_name" {
  type        = string  # The variable type is string, as it stores the base name for EBS volumes
  description = "Base name for the EBS volume"  # Provides a description for the base name of the volume
  default     = "ebs"  # The default value is "ebs", but it can be overridden by providing a different value
}

# Bitnami Helm repository configuration
# This variable stores the URL of the Bitnami Helm repository. It is used for chart installation via Helm.
variable "bitnami_repository" {
  type        = string  # The type is string since the repository URL is a string value
  description = "Bitnami Helm repository"  # Describes the URL to the Bitnami Helm chart repository
  default     = "oci://registry-1.docker.io/bitnamicharts"  # Default repository URL for Bitnami charts
}

# Grafana Prometheus URL configuration
# The Prometheus URL used by Grafana for monitoring purposes. This is the endpoint from which Grafana fetches metrics.
variable "grafana_prometheus_url" {
  type        = string  # The type is string because the URL is a string
  description = "Prometheus URL for Grafana"  # Describes the Prometheus URL used by Grafana for monitoring
  default     = "https://prometheus.staging.cifarm.starci.net"  # Default Prometheus URL for staging environment
}

# Grafana Prometheus Alertmanager URL configuration
# This variable stores the URL of the Prometheus Alertmanager, which sends alerts to Grafana when thresholds are reached.
variable "grafana_prometheus_alertmanager_url" {
  type        = string  # The type is string for the Alertmanager URL
  description = "Prometheus Alertmanager URL for Grafana"  # Describes the Alertmanager URL for Grafana
  default     = "https://prometheus-alertmanager.staging.cifarm.starci.net"  # Default URL for Alertmanager
}