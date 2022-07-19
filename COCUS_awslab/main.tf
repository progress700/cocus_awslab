# aws provider
provider "aws" {
  region  = var.aws_region
  profile = "cocus"
}
/*provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}*/
# vpc
resource "aws_vpc" "awslab-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "awslab-vpc"
  }
}

# internet gateway attach to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.awslab-vpc.id

  tags = {
    Name = "awslab-igw"
  }
}

# data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# public subnet 
resource "aws_subnet" "awslab-subnet-public" {
  vpc_id                  = aws_vpc.awslab-vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "awslab-subnet-public"
  }
}

# route table for public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.awslab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "awslab public route"
  }
}

# associate public subnet to public route table"
resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id      = aws_subnet.awslab-subnet-public.id
  route_table_id = aws_route_table.public_route_table.id
}

# private database subnet 
resource "aws_subnet" "awslab-subnet-private" {
  vpc_id                  = aws_vpc.awslab-vpc.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "awslab-subnet-private"
  }
}

# Allocate Elastic IP Address (awslab-eip)
resource "aws_eip" "eip-for-nat-gateway" {
  vpc = true

  tags = {
    Name = "awslab-eip"
  }
}

# Nat Gateway for public Subnet
resource "aws_nat_gateway" "awslab-nat-gateway" {
  allocation_id = aws_eip.eip-for-nat-gateway.id
  subnet_id     = aws_subnet.awslab-subnet-public.id

  tags = {
    Name = "awslab nat gateway"
  }
}

# Private route table, Add route through Nat Gateway
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.awslab-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.awslab-nat-gateway.id
  }

  tags = {
    Name = "awslab private route"
  }
}

# Associate Private Subnet  with "Private Route Table"
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.awslab-subnet-private.id
  route_table_id = aws_route_table.private-route-table.id
}

# data source to get a registered amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# launch ec2 instance in public subnet
resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.awslab-subnet-public.id
  vpc_security_group_ids = [aws_security_group.webserver-security-group.id]
  key_name               = "awslab-kp"

  tags = {
    Name = "webserver"
  }
}

# launch ec2 instance in private subnet
resource "aws_instance" "database_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.awslab-subnet-private.id
  vpc_security_group_ids = [aws_security_group.database-security-group.id]
  key_name               = "awslab-kp"

  tags = {
    Name = "database server"
  }
}