# Specifies the source location of the Terraform module, which in this case is the EKS module in the AWS infrastructure.
terraform {
  source = "../../../modules/aws/kubernetes"  # Path to the shared Kubernetes module, relative to the current Terragrunt configuration.
}

# Defines a dependency on the VPC module located in the parent directory under "../vpc".
# This allows you to use outputs like private_subnet_ids and vpc_id from the VPC module.
dependency "eks" {
  config_path = "../eks"  # Path to the VPC module, which contains network-related configurations (VPC, subnets, etc.).
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
    cluster_name      = dependency.eks.outputs.cluster_name,  # Adds the EKS cluster name from the EKS dependency.
    primary_node_group_name = dependency.eks.outputs.primary_node_group_name,  # Adds the primary node group name from the EKS dependency.
    secondary_node_group_name = dependency.eks.outputs.secondary_node_group_name,  # Adds the secondary node group name from the EKS dependency.
    cluster_autoscaler_iam_role_arn = dependency.eks.outputs.cluster_autoscaler_iam_role_arn,  # Adds the Cluster Autoscaler IAM role ARN.
  }
)