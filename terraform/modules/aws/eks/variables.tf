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

variable "primary_node_instance_type" {
  type        = set(string)  // Specifies the EC2 instance type for the primary node group
  description = "Primary node instance type"
  default     = ["c5.large"]  // Default instance type is c5.large
}

variable "min_size_primary_node_group" {
  type        = number  // Minimum number of nodes in the primary node group
  description = "Minimum number of nodes in the primary node group"
  default     = 1  // Default is 1 node
}

variable "max_size_primary_node_group" {
  type        = number  // Maximum number of nodes in the primary node group
  description = "Maximum number of nodes in the primary node group"
  default     = 2  // Default maximum is 2 nodes
}

variable "desired_size_primary_node_group" {
  type        = number  // Desired number of nodes in the primary node group
  description = "Desired number of nodes in the primary node group"
  default     = 1  // Default desired size is 1 node
}

variable "disk_size_primary_node_group" {
  type        = number  // Disk size for the primary node group in GB
  description = "Disk size for the primary node group"
  default     = 50  // Default disk size is 50 GB
}

# Node Group configuration for the secondary node group

variable "secondary_node_instance_type" {
  type        = set(string)  // Specifies the EC2 instance type for the secondary node group
  description = "Secondary node instance type"
  default     = ["c5.large"]  // Default instance type is c5.large
}

variable "min_size_secondary_node_group" {
  type        = number  // Minimum number of nodes in the secondary node group
  description = "Minimum number of nodes in the secondary node group"
  default     = 1  // Default is 1 node
}

variable "max_size_secondary_node_group" {
  type        = number  // Maximum number of nodes in the secondary node group
  description = "Maximum number of nodes in the secondary node group"
  default     = 1  // Default maximum is 1 node
}

variable "desired_size_secondary_node_group" {
  type        = number  // Desired number of nodes in the secondary node group
  description = "Desired number of nodes in the secondary node group"
  default     = 1  // Default desired size is 1 node
}

variable "disk_size_secondary_node_group" {
  type        = number  // Disk size for the secondary node group in GB
  description = "Disk size for the secondary node group"
  default     = 100  // Default disk size is 50 GB
}

variable "private_subnet_ids" {
  type = list(string)
  description = "List of private subnet IDs"
}