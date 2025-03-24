provider-region = "us-east-1"
vpc-name = "marvel-vpc"
vpc_range = "197.0.0.0/26"
instance_tenancy = "default"
enable_dns_hostnames = true
enable_dns_support = true
map_public_ip_on_launch = true
cidr = [
  "197.0.0.0/28",  # Public Subnet 1
  "197.0.0.16/28", # Public Subnet 2
  "197.0.0.32/28", # Private Subnet 1
  "197.0.0.48/28"  # Private Subnet 2
]
availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c",
  "us-east-1d"
]
tags = [
  "pub-subnet-1",
  "pub-subnet-2",
  "pri-subnet-1",
  "pri-subnet-2"
]
igw_name                = "marvel-igw"
public_route_table_name = "pub-rt"
private_route_table_name = "pri-rt"
nat_gateway_name        = "marvel-nat"
custom-vpc-sg = "marvel-sg"
cidr_block = "0.0.0.0/0"
