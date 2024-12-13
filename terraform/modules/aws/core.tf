module "core" {
  # Source of the core module. This points to the directory where the module's configuration is defined.
  # In this case, it's the "./core" directory relative to the current Terraform working directory.
  source = "./core"
  
  # AWS region where resources will be created. This value is passed to the core module.
  region = var.region
  
  # AWS Access Key for authenticating to AWS.
  # It is sensitive and should be managed securely.
  access_key = var.access_key
  
  # AWS Secret Key for secure authentication to AWS.
  # It is sensitive and should not be exposed in logs or outputs.
  secret_key = var.secret_key
  
  # The name of the EKS cluster.
  # This is passed to the core module to configure resources dependent on the EKS cluster.
  cluster_name = var.cluster_name
  
  # Grafana user for accessing the Grafana dashboard.
  # The username is passed from the variables and is used for authentication in Grafana.
  grafana_user = var.grafana_user
  
  # Grafana password for user authentication.
  # This password is sensitive and should be handled carefully to avoid exposure.
  grafana_password = var.grafana_password
  
  # PostgreSQL password for the Gameplay database.
  # This password is sensitive and is used to connect to the database securely.
  gameplay_postgres_password = var.gameplay_postgres_password
  
  # Name of the Gameplay PostgreSQL database.
  # This name is passed to the core module to configure PostgreSQL-related resources.
  gameplay_postgres_database = var.gameplay_postgres_database

  # Desired size for the primary node group in the EKS cluster.
  # The number of nodes that should be in the primary node group for this cluster.
  desired_size_primary_node_group = var.desired_size_primary_node_group

  # Minimum size for the primary node group in the EKS cluster.
  # This ensures that there will be at least this number of nodes in the primary node group.
  min_size_primary_node_group = var.min_size_primary_node_group

  # Maximum size for the primary node group in the EKS cluster.
  # This ensures that the number of nodes in the primary node group does not exceed this value.
  max_size_primary_node_group = var.max_size_primary_node_group

  # Instance type for the primary node group in the EKS cluster.
  # This determines the type of EC2 instances that will be used for the primary nodes.
  primary_node_instance_type = var.primary_node_instance_type

  # Disk size for the primary node group in the EKS cluster.
  # The amount of disk space to allocate to the EC2 instances in the primary node group.
  disk_size_primary_node_group = var.disk_size_primary_node_group

  # Instance type for the secondary node group in the EKS cluster.
  # This determines the type of EC2 instances that will be used for the secondary nodes.
  secondary_node_instance_type = var.secondary_node_instance_type

  # Minimum size for the secondary node group in the EKS cluster.
  # This ensures that there will be at least this number of nodes in the secondary node group.
  min_size_secondary_node_group = var.min_size_secondary_node_group

  # Maximum size for the secondary node group in the EKS cluster.
  # This ensures that the number of nodes in the secondary node group does not exceed this value.
  max_size_secondary_node_group = var.max_size_secondary_node_group

  # Desired size for the secondary node group in the EKS cluster.
  # The number of nodes that should be in the secondary node group for this cluster.
  desired_size_secondary_node_group = var.desired_size_secondary_node_group

  # Disk size for the secondary node group in the EKS cluster.
  # The amount of disk space to allocate to the EC2 instances in the secondary node group.
  disk_size_secondary_node_group = var.disk_size_secondary_node_group
}
