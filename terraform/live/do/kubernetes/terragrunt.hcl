# Specifies the source location of the Terraform module, which in this case is the EKS module in the AWS infrastructure.
terraform {
  source = "../../../modules/do/kubernetes"  # Path to the shared Kubernetes module, relative to the current Terragrunt configuration.
}

# The locals block defines local variables for use within the configuration.
# Here, it's used to dynamically load environment-specific variables from a configuration file.
locals {
  # The 'get_env' function retrieves the value of the 'env' environment variable (or defaults to "dev" if not set).
  # It then uses 'find_in_parent_folders' to locate the corresponding HCL file, such as 'vars.dev.hcl' or 'vars.prod.hcl'.
  # 'read_terragrunt_config' reads the configuration file and stores the result in 'common_vars'.
  common_vars = read_terragrunt_config(find_in_parent_folders("vars.dev.hcl"))
}

# It uses the 'merge' function to combine:
# - Inputs from the environment-specific configuration file loaded above (local.common_vars.inputs)
# - Additional values from the VPC dependency (private_subnet_ids and vpc_id).
inputs = merge(
  local.common_vars.inputs,  # Merges the inputs from the environment-specific file into the inputs block.
  {}
)