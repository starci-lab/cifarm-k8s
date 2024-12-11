# Create a VPC
module "vpc" {
  # Define the source of the module
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  # Define the name of the VPC
  name            = local.cluster_name
  # Define the CIDR block of the VPC
  cidr            = "10.0.0.0/16"
  # Define the availability zones
  azs             = data.aws_availability_zones.available.names
  # Define the private subnets
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  # Define the public subnets
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  # Enable NAT gateway
  enable_nat_gateway   = true
  # Use a single NAT gateway
  single_nat_gateway   = true
  # Enable DNS hostnames
  enable_dns_hostnames = true

  # Define the tags for the VPC
  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  # Define the tags for the public subnets
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  # Define the tags for the private subnets
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

