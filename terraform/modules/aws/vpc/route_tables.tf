# Create a route table for the specified VPC
resource "aws_route_table" "rt-private" {
  # The VPC this route table is associated with
  vpc_id = aws_vpc.vpc.id

  # Define a route for outbound traffic (0.0.0.0/0)
  # This matches all traffic and routes it through the NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"  # Matches all traffic destined for outside the VPC (Internet)
    nat_gateway_id = aws_nat_gateway.nat.id  # The NAT Gateway used to route the traffic
  }

  # Define a route for internal traffic within the VPC (10.0.0.0/16)
  # This ensures that traffic within the VPC (e.g., between subnets) remains internal
  route {
    cidr_block = "10.0.0.0/16"  # Matches all traffic within the VPC network range
    gateway_id = "local"  # This is the default route for local VPC traffic (it stays within the VPC)
  }

  # Tags to help identify the route table (for management purposes)
  tags = {
    Name = "rt-private-${var.cluster_name}"  # Name of the route table, dynamically generated based on the cluster name
  }
}

# Associate private subnets with the route table using for_each
resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private_subnets  # Iterate over the private subnets resource

  subnet_id      = each.value.id  # Access the subnet ID correctly from the private_subnets resource
  route_table_id = aws_route_table.rt-private.id
}

# Create a route table for the public subnets
resource "aws_route_table" "rt-public" {
  # The VPC this route table is associated with
  vpc_id = aws_vpc.vpc.id

  # Define a route for outbound traffic (0.0.0.0/0) through the Internet Gateway (IGW)
  route {
    cidr_block = "0.0.0.0/0"  # Matches all traffic destined for the internet
    gateway_id = aws_internet_gateway.igw.id  # The Internet Gateway used to route the traffic
  }

  # Define a route for internal traffic within the VPC (10.0.0.0/16)
  # This ensures that traffic within the VPC (e.g., between subnets) remains internal
  route {
    cidr_block = "10.0.0.0/16"  # Matches all traffic within the VPC network range
    gateway_id = "local"  # This is the default route for local VPC traffic
  }

  # Tags to help identify the route table (for management purposes)
  tags = {
    Name = "rt-public-${var.cluster_name}"  # Name of the route table, dynamically generated based on the cluster name
  }
}

# Associate the public subnets with the route table using for_each
resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public_subnets  # Iterate over the public subnets resource

  subnet_id      = each.value.id  # Access the subnet ID correctly from the public_subnets resource
  route_table_id = aws_route_table.rt-public.id  # Reference the public route table ID
}