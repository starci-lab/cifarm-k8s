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

##############################################

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
  default     = 50  // Default disk size is 50 GB
}