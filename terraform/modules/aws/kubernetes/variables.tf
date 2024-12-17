// AWS credentials
# Region where AWS resources will be deployed.
# The `region` variable is used to specify the AWS region for the resources.
variable "region" {
  type = string
  default     = "ap-southeast-1"  # Default region is set to "ap-southeast-1" (Singapore)
  description = "AWS region"  # Description to specify that this is the region for deployment
}

# AWS access key for programmatic access to AWS.
# The `access_key` variable holds the AWS access key that provides access to AWS services.
# This key is sensitive and should not be exposed in logs or outputs.
variable "access_key" {
  type = string
  description = "AWS access key"  # Description clarifying that this is the AWS access key
  sensitive = true  # Marks this variable as sensitive to prevent it from being displayed in logs
}

# AWS secret key corresponding to the access key.
# The `secret_key` variable holds the AWS secret key that complements the access key and provides secure access.
# This key is sensitive and should be handled securely.
variable "secret_key" {
  type = string
  description = "AWS secret key"  # Description clarifying that this is the AWS secret key
  sensitive = true  # Marks this variable as sensitive to prevent it from being displayed in logs
}

# Name of the EKS cluster to be created.
# The `cluster_name` variable is used to specify the name of the EKS cluster that will be created.
variable "cluster_name" {
  type        = string  # Specifies that this variable is of type string
  description = "Name of the EKS cluster"  # Description to specify that this variable holds the name of the EKS cluster
}

##################################################
# Base configuration for the EKS cluster
### Databases
# PostgreSQL database configuration for gameplay
# The variable stores the name of the PostgreSQL database used for gameplay purposes. 
variable "gameplay_postgres_database" {
  description = "The Gameplay PostgreSQL database name"  # Description of the database name variable
  type        = string  # The variable type is string, as it stores the name of the database
  sensitive   = true  # Marks the value as sensitive to avoid exposure in logs
}

# PostgreSQL password configuration for gameplay
# The variable stores the password for the Gameplay PostgreSQL database. It is sensitive to maintain security.
variable "gameplay_postgres_password" {
  description = "The Gameplay PostgreSQL password"  # Describes the password variable for the PostgreSQL database
  type        = string  # The variable type is string as it holds a password
  sensitive   = true  # Marks the password as sensitive
}

# Grafana user configuration
# Stores the Grafana user credentials for logging into the Grafana dashboard.
variable "grafana_user" {
  type        = string  # The variable type is string, storing the username for Grafana login
  description = "Grafana user"  # Describes the user variable for Grafana access
  sensitive   = true  # The username is marked as sensitive to avoid exposure
}

# Grafana password configuration
# Stores the Grafana password for the user specified in the previous variable.
variable "grafana_password" {
  type        = string  # The variable type is string, as it stores the password
  description = "Grafana password"  # Describes the password variable for Grafana access
  sensitive   = true  # The password is marked as sensitive to protect security
}

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

variable "system_namespace" {
  type        = string  # The type is string for the system namespace
  description = "System namespace for Kubernetes resources"  # Describes the system namespace for Kubernetes resources
  default     = "kube-system"  # Default system namespace is "kube-system"
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

# Variable for the primary node group name in an EKS cluster.
# This is used to define the name of the primary node group that will be created.
variable "primary_node_group_name" {
  type        = string  # Specifies that the value of this variable will be a string.
  description = "Primary node group name"  # Describes the purpose of the variable as the primary node group name.
}

# Variable for the secondary node group name in an EKS cluster.
# This is used to define the name of the secondary node group that will be created.
variable "secondary_node_group_name" {
  type        = string  # Specifies that the value of this variable will be a string.
  description = "Secondary node group name"  # Describes the purpose of the variable as the secondary node group name.
}

variable "cluster_autoscaler_iam_role_arn" {
  type        = string  # Specifies that the value of this variable will be a string.
  description = "IAM role ARN for the Cluster Autoscaler"  # Describes the purpose of the variable as the IAM role ARN for the Cluster Autoscaler.
}