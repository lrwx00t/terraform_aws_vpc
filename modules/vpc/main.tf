### Network

# Internet VPC
resource "aws_vpc" "application_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "${var.environment}_application_vpc"
  }
}

# Subnets
resource "aws_subnet" "public_subnets" {
  # Fix: missing attribute value in the public_subnets resource. Need to assign a value for the VPC id of the applica_vpc resource in the previous block.
  # vpc_id                  = 
  vpc_id                  = aws_vpc.application_vpc.id
  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  # FIX: missing value for the attribute count in the public_subnets resource. The value has been set to match the number/length of elements in the public_subnet_cidr_blocks
  # count                   = 
  count                   = length(var.public_subnet_cidr_blocks)

  tags = {
    Name = "${var.environment}_public_subnet_${substr(element(var.availability_zones, count.index), -1, 1)}"
  }
}

resource "aws_subnet" "private_subnets" {
  # Implement this resource
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.application_vpc.id

  tags = {
    Name = "${var.environment}_internet_gw"
  }
}

# route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.application_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # FIX: missing value for the gateway_id attribute in the public_rt resource. Assigning the value of the internet gateway id for the public routing table resource
    # gateway_id = 
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "${var.environment}_public_rt"
  }
}

# NAT EIPs
resource "aws_eip" "nat_eip" {
  vpc   = true
  count = length(aws_subnet.public_subnets)

  tags = {
    Name = "${var.environment}_nat_eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)
  count         = length(aws_subnet.public_subnets)

  tags = {
    Name = "${var.environment}_nat_gw"
  }
}

resource "aws_route_table" "lambda_function_rt" {
  vpc_id = aws_vpc.application_vpc.id
  count  = length(aws_nat_gateway.nat_gw)

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gw.*.id, count.index)
  }

  tags = {
    Name = "${var.environment}_lambda_function_rt_${substr(element(var.availability_zones, count.index), -1, 1)}"
  }
}

# private subnet route table associations
resource "aws_route_table_association" "private_rta" {
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  # FIX: missing count index in the route_table_id of the private_rta resource. Need to specify the count index so terrraform can iterate over the list of the RT associated with each subnet_id. 
  # route_table_id = aws_route_table.lambda_function_rt[].id
  # Note: While there is another syntax that can be used here e.g. element, I used [count.index] instead of element as described in Terraform official doco: Use the built-in index syntax list[index] in most cases. Use this function only for the special additional "wrap-around" behavior described below.
  # Ref: https://www.terraform.io/language/functions/element
  route_table_id = aws_route_table.lambda_function_rt[count.index].id
  count          = length(aws_subnet.private_subnets)
}

# public subnet route table associations
resource "aws_route_table_association" "public_rta" {
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
  count          = length(aws_subnet.public_subnets)
}
