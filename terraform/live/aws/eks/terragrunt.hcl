# Specifies the source location of the Terraform module, which in this case is the EKS module in the AWS infrastructure.
terraform {
  source = "../../../modules/aws/eks"  # Path to the EKS module, relative to the current Terragrunt configuration.
}

# Defines a dependency on the VPC module located in the parent directory under "../vpc".
# This allows you to use outputs like private_subnet_ids and vpc_id from the VPC module.
dependency "vpc" {
  config_path = "../vpc"  # Path to the VPC module, which contains network-related configurations (VPC, subnets, etc.).
}

# The locals block defines local variables for use within the configuration.
# Here, it's used to dynamically load environment-specific variables from a configuration file.
locals {
  # The 'get_env' function retrieves the value of the 'env' environment variable (or defaults to "dev" if not set).
  # It then uses 'find_in_parent_folders' to locate the corresponding HCL file, such as 'vars.dev.hcl' or 'vars.prod.hcl'.
  # 'read_terragrunt_config' reads the configuration file and stores the result in 'common_vars'.
  common_vars = read_terragrunt_config(find_in_parent_folders("vars.dev.hcl"))
}

# The 'inputs' block is used to pass values into the Terraform module.
# It uses the 'merge' function to combine:
# - Inputs from the environment-specific configuration file loaded above (local.common_vars.inputs)
# - Additional values from the VPC dependency (private_subnet_ids and vpc_id).
inputs = merge(
  local.common_vars.inputs,  # Merges the inputs from the environment-specific file into the inputs block.
  {
    private_subnet_ids = dependency.vpc.outputs.private_subnet_ids,  # Adds private subnet IDs from the VPC dependency.
    vpc_id             = dependency.vpc.outputs.vpc_id,  # Adds VPC ID from the VPC dependency.
  }
)