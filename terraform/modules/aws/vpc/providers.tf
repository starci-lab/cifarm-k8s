# AWS provider configuration
provider "aws" {
  # The AWS region where the resources will be created. This is provided as a variable.
  region     = var.region

  # AWS Access Key for authentication. It should be securely handled (e.g., using environment variables or secrets manager).
  access_key = var.access_key

  # AWS Secret Key for authentication. Again, this should be securely handled.
  secret_key = var.secret_key
}

# Data source to fetch the available AWS Availability Zones in the specified region
data "aws_availability_zones" "available" {
  # No additional arguments required, it will fetch all available availability zones in the region.
}