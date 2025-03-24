# Create VPC
resource "aws_vpc" "marvel-vpc" {
  cidr_block           = var.vpc-range
  instance_tenancy     = var.instance_tenancy #dedicated or host
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = var.vpc-name
  }
}

# Create Public Subnet 1
resource "aws_subnet" "pub-subnet-1" {
  vpc_id                  = aws_vpc.marvel-vpc.id
  cidr_block              = var.cidr[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone = var.availability_zones[0]

  tags = {
    Name = var.tags[0]
  }
}

# Create Public Subnet 2
resource "aws_subnet" "pub-subnet-2" {
  vpc_id                  = aws_vpc.marvel-vpc.id
  cidr_block              = var.cidr[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone = var.availability_zones[1]

  tags = {
    Name = var.tags[1]
  }
}

# Create Private Subnet 1
resource "aws_subnet" "pri-subnet-1" {
  vpc_id     = aws_vpc.marvel-vpc.id
  cidr_block = var.cidr[2]
  availability_zone = var.availability_zones[2]

  tags = {
    Name = var.tags[2]
  }
}

# Create Private Subnet 2
resource "aws_subnet" "pri-subnet-2" {
  vpc_id     = aws_vpc.marvel-vpc.id
  cidr_block = var.cidr[3]
  availability_zone = var.availability_zones[3]
  tags = {
    Name = var.tags[3]
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "marvel-igw" {
  vpc_id = aws_vpc.marvel-vpc.id

  tags = {
    Name = var.igw_name
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.marvel-vpc.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.marvel-igw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}
# Create Route Table for Private Subnets
resource "aws_route_table" "pri-rt" {
  vpc_id = aws_vpc.marvel-vpc.id

  tags = {
    Name = var.private_route_table_name
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.pub-subnet-1.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.pub-subnet-2.id
  route_table_id = aws_route_table.pub-rt.id
}
# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_subnet_1_assoc" {
  subnet_id      = aws_subnet.pri-subnet-1.id
  route_table_id = aws_route_table.pri-rt.id
}

resource "aws_route_table_association" "private_subnet_2_assoc" {
  subnet_id      = aws_subnet.pri-subnet-2.id
  route_table_id = aws_route_table.pri-rt.id
}


# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.marvel-igw]
}

# Create NAT Gateway in a Public Subnet
resource "aws_nat_gateway" "marvel-nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub-subnet-1.id

  tags = {
    Name = var.nat_gateway_name
  }
}
# Add Route in Private Route Table for NAT Gateway
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.pri-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.marvel-nat.id
}
resource "aws_security_group" "custom_sg" {
  name        = var.custom-vpc-sg
  vpc_id      = aws_vpc.marvel-vpc.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = "Allow port ${ingress.value.port}"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.custom-vpc-sg
  }
}

locals {
  ingress_rules = [
    { port = 443 },
    { port = 22 },
    { port = 80 },
    { port = 8080 },
    { port = 9000 }
  ]
}


