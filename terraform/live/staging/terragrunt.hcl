terraform {
  source = "../../modules/aws"  // Path to the Terraform module containing the AWS resources
}

inputs = {
  region        = "ap-southeast-1"            // AWS region to be used for the resources
  cluster_name  = "cifarm-staging-1"         // Name of the EKS cluster

   # Primary Node Group Configuration
  primary_node_instance_type        = ["c5.large"]  // EC2 instance type for the primary node group
  min_size_primary_node_group      = 1  // Minimum number of nodes in the primary node group
  max_size_primary_node_group      = 2  // Maximum number of nodes in the primary node group
  desired_size_primary_node_group  = 1  // Desired number of nodes in the primary node group
  disk_size_primary_node_group     = 50  // Disk size for the primary node group in GB

  # Secondary Node Group Configuration
  secondary_node_instance_type     = ["c5.large"]  // EC2 instance type for the secondary node group
  min_size_secondary_node_group    = 1  // Minimum number of nodes in the secondary node group
  max_size_secondary_node_group    = 1  // Maximum number of nodes in the secondary node group
  desired_size_secondary_node_group = 1  // Desired number of nodes in the secondary node group
  disk_size_secondary_node_group   = 50  // Disk size for the secondary node group in GB
}