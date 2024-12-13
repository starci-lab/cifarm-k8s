# Variable to store the VPC ID
variable "vpc_id" {
  type        = string  # Specifies that this variable is a string type
  description = "The ID of the VPC"  # Describes that this variable holds the ID of the VPC
}

# Variable to store the IDs of the private subnets
variable "private_subnet_ids" {
  type        = list(string)  # Specifies that this variable is a list of strings, where each string is a subnet ID
  description = "The IDs of the private subnets"  # Describes that this variable holds the list of private subnet IDs
}