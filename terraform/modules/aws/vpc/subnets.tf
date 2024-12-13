locals {
  subnet_roles = ["elb", "elb-internal"]  # Public (elb) and private (elb-internal) roles
  az_names     = data.aws_availability_zones.available.names

  # Ensure unique CIDR blocks for public and private subnets
  public_subnets = flatten([
    for i, az_name in local.az_names : [
      {
        name       = "public-${i + 1}"  # Name the subnet as 'public-1', 'public-2', etc.
        cidr_block = "10.0.${i * 2 + 1}.0/24"  # Public subnets with odd CIDR blocks
        role       = "elb"  # Set the role as 'elb' for public subnets
        az_index   = i  # The index of the AZ
        az_name    = az_name  # The name of the AZ (e.g., us-east-1a)
      }
    ]
  ])

  private_subnets = flatten([
    for i, az_name in local.az_names : [
      {
        name       = "private-${i + 1}"  # Name the subnet as 'private-1', 'private-2', etc.
        cidr_block = "10.0.${i * 2 + 2}.0/24"  # Private subnets with even CIDR blocks (ensure no overlap)
        role       = "elb-internal"  # Set the role as 'elb-internal' for private subnets
        az_index   = i  # The index of the AZ
        az_name    = az_name  # The name of the AZ (e.g., us-east-1a)
      }
    ]
  ])
}

# Define public subnets
resource "aws_subnet" "public_subnets" {
  for_each = { for subnet in local.public_subnets : subnet.name => subnet }

  # Subnet properties
  vpc_id             = aws_vpc.vpc.id
  cidr_block         = each.value.cidr_block
  availability_zone  = each.value.az_name

  tags = {
    Name = "subnet-${var.cluster_name}-public-${each.value.az_name}"
    "kubernetes.io/role/${each.value.role}" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Define private subnets
resource "aws_subnet" "private_subnets" {
  for_each = { for subnet in local.private_subnets : subnet.name => subnet }

  # Subnet properties
  vpc_id             = aws_vpc.vpc.id
  cidr_block         = each.value.cidr_block
  availability_zone  = each.value.az_name

  tags = {
    Name = "subnet-${var.cluster_name}-private-${each.value.az_name}"
    "kubernetes.io/role/${each.value.role}" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}