# Output the VPC ID of the created VPC
output "vpc_id" {
  value = aws_vpc.vpc.id  # The ID of the VPC resource, which is created or referenced earlier in the configuration
}

# Output the IDs of all private subnets
output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]  # A list comprehension that collects the 'id' of each subnet in the 'private_subnets' collection
}