// AWS credentials
variable "region" {
  type = string
  default     = "ap-southeast-1"
  description = "AWS region"
}

variable "access_key" {
  type = string
  description = "AWS access key"
  sensitive = true
}

variable "secret_key" {
  type = string
  description = "AWS secret key"
  sensitive = true
}

// EKS cluster
variable "cluster_base_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "cifarm"
}

// EKS Node Groups
// Primary Node Group
variable "primary_node_base_group_name" {
  type        = string
  description = "Primary node group name"
  default     = "primary"
}

variable "primary_node_instance_type" {
  type        = set(string)
  description = "Primary node instance type"
  default     = ["c5.large"]
}

variable "min_size_primary_node_group" {
  type        = number
  description = "Minimum number of nodes in the primary node group"
  default     = 1
}

variable "max_size_primary_node_group" {
  type        = number
  description = "Maximum number of nodes in the primary node group"
  default     = 2
}

variable "desired_size_primary_node_group" {
  type        = number
  description = "Desired number of nodes in the primary node group"
  default     = 1
}

variable "disk_size_primary_node_group" {
  type        = number
  description = "Disk size for the primary node group"
  default     = 50
}

//Secondary Node Group
variable "secondary_node_base_group_name" {
  type        = string
  description = "Secondary node group name"
  default     = "secondary"
}

variable "secondary_node_instance_type" {
  type        = set(string)
  description = "Secondary node instance type"
  default     = ["c5.large"]
}

variable "min_size_secondary_node_group" {
  type        = number
  description = "Minimum number of nodes in the secondary node group"
  default     = 1
}

variable "max_size_secondary_node_group" {
  type        = number
  description = "Maximum number of nodes in the secondary node group"
  default     = 1
}

variable "desired_size_secondary_node_group" {
  type        = number
  description = "Desired number of nodes in the secondary node group"
  default     = 1
}

variable "disk_size_secondary_node_group" {
  type        = number
  description = "Disk size for the secondary node group"
  default     = 50
}

variable "ebs_volume_az" {
  type        = string
  description = "Availability zone for the EBS volume"
  default     = "us-southeast-1a"
}

variable "ebs_volume_size" {
  type        = number
  description = "Size of the EBS volume"
  default     = 20
}