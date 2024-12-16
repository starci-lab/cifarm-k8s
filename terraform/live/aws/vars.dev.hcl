# Development Environment Variables
inputs = {
  # Primary Node Group Variables
  primary_node_instance_type         = ["c5.large"]
  min_size_primary_node_group        = 1
  max_size_primary_node_group        = 2
  desired_size_primary_node_group    = 1
  disk_size_primary_node_group       = 30

  # Secondary Node Group Variables
  secondary_node_instance_type       = ["c5.large"]
  min_size_secondary_node_group      = 1
  max_size_secondary_node_group      = 1
  desired_size_secondary_node_group  = 1
  disk_size_secondary_node_group     = 30

  # Cluster Name
  cluster_name = "cifarm-dev"

  # Grafana
  grafana_prometheus_url = "https://prometheus.cifarm.dev.starci.net"
  grafana_prometheus_alertmanager_url = "https://prometheus-alertmanager.cifarm.dev.starci.net"
}