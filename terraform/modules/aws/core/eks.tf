module "eks" {
  # Source of the EKS module
  # This references the local path where the EKS module is defined (./eks).
  source = "../eks"

  # AWS Region for the EKS cluster
  # The region where the EKS cluster and associated resources will be created.
  region = var.region

  # AWS Access Key
  # The access key required to authenticate and interact with AWS services.
  # This key will be provided as an input variable for accessing AWS resources.
  access_key = var.access_key

  # AWS Secret Key
  # The secret key associated with the access key for secure AWS authentication.
  # It will be passed as an input variable to avoid hardcoding sensitive information.
  secret_key = var.secret_key

  # Cluster Name
  # The name of the EKS cluster is dynamically generated using the 'var.cluster_name' value.
  cluster_name = var.cluster_name

  # Primary Node Group Configuration
  # These variables define the scaling and instance type configuration for the primary node group.

  # Desired size of the primary node group (how many nodes to launch).
  desired_size_primary_node_group = var.desired_size_primary_node_group

  # Minimum size of the primary node group (the smallest number of nodes).
  min_size_primary_node_group = var.min_size_primary_node_group

  # Maximum size of the primary node group (the largest number of nodes).
  max_size_primary_node_group = var.max_size_primary_node_group

  # Instance type to use for the primary node group.
  # Defines the EC2 instance type (e.g., c5.large) for the primary nodes.
  primary_node_instance_type = var.primary_node_instance_type

  # Disk size (in GB) for the primary node group.
  # Specifies the size of the disk attached to each instance in the primary node group.
  disk_size_primary_node_group = var.disk_size_primary_node_group

  # Secondary Node Group Configuration
  # These variables define the scaling and instance type configuration for the secondary node group.

  # Instance type to use for the secondary node group.
  secondary_node_instance_type = var.secondary_node_instance_type

  # Minimum size of the secondary node group.
  min_size_secondary_node_group = var.min_size_secondary_node_group

  # Maximum size of the secondary node group.
  max_size_secondary_node_group = var.max_size_secondary_node_group

  # Desired size of the secondary node group.
  desired_size_secondary_node_group = var.desired_size_secondary_node_group

  # Disk size (in GB) for the secondary node group.
  disk_size_secondary_node_group = var.disk_size_secondary_node_group
}