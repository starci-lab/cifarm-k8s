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