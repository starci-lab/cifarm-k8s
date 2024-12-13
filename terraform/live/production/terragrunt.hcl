
terraform {
  source = "../core"
}

# Defined in the root module
inputs = {
  # Primary Node Group Variables
  primary_node_group_name            = "primary-staging"
  primary_node_instance_type         = ["c5.large"]
  min_size_primary_node_group        = 1
  max_size_primary_node_group        = 3
  desired_size_primary_node_group    = 1
  disk_size_primary_node_group       = 50

  # Secondary Node Group Variables
  secondary_node_group_name          = "secondary-staging"
  secondary_node_instance_type       = ["c5.large"]
  min_size_secondary_node_group      = 1
  max_size_secondary_node_group      = 1
  desired_size_secondary_node_group  = 1
  disk_size_secondary_node_group     = 50

  # Clound Provider
  clound = "aws"

  # Cluster Base Name
  cluster_base_name = "cifarm-production"

    # Grafana
  grafana_prometheus_url = "https://prometheus.cifarm.starci.net"
  grafana_prometheus_alertmanager_url = "https://prometheus-alertmanager.cifarm.starci.net"
}