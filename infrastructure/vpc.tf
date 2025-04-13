provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  backend "s3" {}
}

// Pipeline lab VPC
resource "aws_vpc" "pipeline-lab-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

// Lab public subnet #1
resource "aws_subnet" "pipeline-lab-public-subnet-1" {
  vpc_id                  = aws_vpc.pipeline-lab-vpc.id
  cidr_block              = var.pipeline-lab-public-subnet-1-cidr
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "Pipeline lab public subnet #1"
  }
}

resource "aws_subnet" "pipeline-lab-public-subnet-2" {
  vpc_id                  = aws_vpc.pipeline-lab-vpc.id
  cidr_block              = var.pipeline-lab-public-subnet-2-cidr
  availability_zone       = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "Pipeline lab public subnet #2"
  }
}

// Lab private subnet #1
resource "aws_subnet" "pipeline-lab-private-subnet-1" {
  vpc_id                  = aws_vpc.pipeline-lab-vpc.id
  cidr_block              = var.pipeline-lab-private-subnet-1-cidr
  availability_zone       = var.az_1
  map_public_ip_on_launch = false

  tags = {
    Name = "Pipine lab private subnet #1"
  }
}

// VPC route table
// IGW implementation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.pipeline-lab-vpc.id

  tags = {
    Name = "igw_${var.vpc_name}"
  }
}

// Public Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.pipeline-lab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_irt_${var.vpc_name}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.pipeline-lab-public-subnet-1.id
  route_table_id = aws_route_table.public_rt.id
}

# // Private Route table
# // NAT instance configuration
# resource "aws_instance" "nat" {
#   ami                         = "ami-05a783b74ab65fa72"
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.pipeline-lab-public-subnet-1.id
#   associate_public_ip_address = true
#   source_dest_check           = false
#
#   tags = {
#     Name = "nat_${var.vpc_name}"
#   }
# }

// Private Route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.pipeline-lab-vpc.id

  # route {
  #   cidr_block  = "0.0.0.0/0"
  #   instance_id = aws_instance.nat.id
  # }
  tags = {
    Name = "private_irt_${var.vpc_name}"
  }
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat.primary_network_interface_id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.pipeline-lab-private-subnet-1.id
  route_table_id = aws_route_table.private_rt.id
}