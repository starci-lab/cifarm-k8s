# Define a module for the VPC resource
module "vpc" {
    # The source of the module, referencing a local directory containing the VPC-related Terraform resources
    source = "../vpc"
    
    # The AWS region where the resources should be deployed
    region = var.region
    
    # The AWS Access Key used for authentication (it is recommended to use IAM roles or AWS profiles instead of hardcoding credentials)
    access_key = var.access_key
    
    # The AWS Secret Key used for authentication (avoid hardcoding for security reasons)
    secret_key = var.secret_key
    
    # The name of the EKS cluster that this VPC will be associated with
    cluster_name = var.cluster_name
}