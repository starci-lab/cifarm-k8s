terraform {
  source = "../../modules//core"
}

# Defined in the root module
inputs = {
  # Primary Node Group Variables
  primary_node_base_group_name       = "primary-staging"
  primary_node_instance_type         = ["c5.large"]
  min_size_primary_node_group        = 1
  max_size_primary_node_group        = 2
  desired_size_primary_node_group    = 1
  disk_size_primary_node_group       = 50

  # Secondary Node Group Variables
  secondary_node_base_group_name     = "secondary-staging"
  secondary_node_instance_type       = ["c5.large"]
  min_size_secondary_node_group      = 1
  max_size_secondary_node_group      = 1
  desired_size_secondary_node_group  = 1
  disk_size_secondary_node_group     = 50

  # Clound Provider
  clound = "aws"

  # Cluster Base Name
  cluster_base_name = "cifarm-staging"

  # EBS
  ebs_volume_size = 20
  ebs_volume_name = "us-west-2a"
}