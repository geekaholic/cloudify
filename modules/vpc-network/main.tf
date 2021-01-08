# Module: vpc-network/main.tf
# Sets up a VPC with AZs, routing and gw

# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_tag_name
  }
}

# Get AZs
data "aws_availability_zones" "azs" {
  state = "available"
}

# Create subnet
resource "aws_subnet" "subnet" {
  count                   = var.az_count
  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
}

# Create gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.vpc.id
}

# Create routing
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = var.vpc_tag_name
  }
}

