## VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = "${merge(tomap({Name = "${var.app_name}-vpc"}), var.tags)}"
}

## Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags
}

## Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = length(var.aws_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.aws_zones[count.index]
  map_public_ip_on_launch = true
  tags                    = var.tags
}

## Private Subnets
resource "aws_subnet" "private_subnet" {
  count                    = length(var.aws_zones)
  vpc_id                   = aws_vpc.main.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.aws_zones))
  availability_zone        = var.aws_zones[count.index]
  map_public_ip_on_launch  = false
  tags                     = var.tags
}

## Nat Gateway
resource "aws_eip" "nat" {
  count = length(var.aws_zones)
  vpc   = true
  tags  = var.tags
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.aws_zones)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  tags          = var.tags
  depends_on    = [aws_eip.nat, aws_internet_gateway.main_igw, aws_subnet.public_subnet]
}

## Routing (public subnets)
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags
  
  # Default route through Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}

resource "aws_route_table_association" "public_subnet_rt_association" {
  count          = length(var.aws_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_subnet_rt.id
}


## Routing (private subnets)
resource "aws_route_table" "private_subnet_rt" {
  count  = length(var.aws_zones)
  vpc_id = aws_vpc.main.id
  tags   = var.tags

  # Default route through NAT
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }
}

resource "aws_route_table_association" "private_subnet_rt_association" {
  count          = length(var.aws_zones) 
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_subnet_rt.*.id, count.index)
}
