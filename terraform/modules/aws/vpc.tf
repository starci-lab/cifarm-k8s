module "vpc" {
  # Source of the VPC module
  # This specifies the path to the VPC module, which defines the creation and configuration of the Virtual Private Cloud (VPC) and associated resources (subnets, security groups, etc.).
  source = "./vpc"

  # AWS Region
  # The AWS region where the VPC and related resources will be created. The value is passed dynamically from the `region` variable.
  region = var.region

  # AWS Access Key
  # The AWS access key is provided to authenticate Terraform against AWS services.
  # It will be passed as an input variable for secure AWS access.
  access_key = var.access_key

  # AWS Secret Key
  # The secret key associated with the AWS access key for secure authentication.
  # This variable helps authenticate the access key when interacting with AWS resources.
  secret_key = var.secret_key

  # Cluster Name
  # The name of the cluster is passed as a variable to the VPC module, allowing it to be used for naming resources like VPC, subnets, etc.
  cluster_name = var.cluster_name
}