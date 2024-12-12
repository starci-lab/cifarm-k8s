# Create an eks cluster
module "eks" {
  # Define the source of the module
  source = "terraform-aws-modules/eks/aws"
  version = "20.31.1"

  # Define the name of the cluster
  cluster_name    = local.cluster_name
  cluster_version = "1.31"

  # Enable the cluster creator admin permissions
  enable_cluster_creator_admin_permissions = true
  
  # Define the VPC ID
  vpc_id                         = module.vpc.vpc_id
  # Define the subnet IDs
  subnet_ids                     = module.vpc.private_subnets
  # Enable public access to the cluster endpoint
  cluster_endpoint_public_access = true

  # Define the IAM role ARN
  create_iam_role = false
  iam_role_arn = aws_iam_role.cluster.arn

  # Define the default settings for the managed node group
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  # Add-ons
  cluster_addons =  {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn = module.ebs_csi_eks_role.iam_role_arn
    }
  }
  # Define the managed node groups
  eks_managed_node_groups = {
    # Define the primary managed node group
    primary_group = {
      name           = local.primary_node_group_name
      instance_types = var.primary_node_instance_type
      min_size       = var.min_size_primary_node_group
      max_size       = var.max_size_primary_node_group
      desired_size   = var.desired_size_primary_node_group
      subnet_ids = module.vpc.private_subnets
      create_iam_role = false
      create_iam_role_policy = false
      
      iam_role_arn = aws_iam_role.primary_node_group.arn
      update_config = {
        max_unavailable = 1
      }
      disk_size = var.disk_size_primary_node_group
    }
    # Define the secondary managed node group
    secondary_group = {
      name           = local.secondary_node_group_name
      instance_types = var.secondary_node_instance_type
      min_size       = var.min_size_secondary_node_group
      max_size       = var.max_size_secondary_node_group
      desired_size   = var.desired_size_secondary_node_group
      subnet_ids = module.vpc.private_subnets
      create_iam_role = false
      create_iam_role_policy = false
      iam_role_arn = aws_iam_role.secondary_node_group.arn
      update_config = {
        max_unavailable = 1
      }
      disk_size = var.disk_size_secondary_node_group
    }
  }
}