// Available Availability Zones in choosen Region
data "aws_availability_zones" "available_zones" {
  state = "available"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "${var.pre_tag}VPC"
    Environment = "${var.tag_environment}"
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.pre_tag}IGW"
    Environment = "${var.tag_environment}"
  }
}

# Public subnets
resource "aws_subnet" "public_subnet" {
  count = "${var.public_subnet_count}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_subnet_cidr[count.index]}"
  availability_zone = "${data.aws_availability_zones.available_zones.names[count.index]}"

  tags {
    Name = "${var.pre_tag}Public-${count.index + 1}"
    Environment = "${var.tag_environment}"
  }
}

# Public route table
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.pre_tag}Public"
    Environment = "${var.tag_environment}"
  }
}

# Attach Internet Gateway to public route
resource "aws_route" "internet" {
  route_table_id = "${aws_route_table.public_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
  depends_on = ["aws_internet_gateway.igw", "aws_route_table.public_rt"]
}

# Route table association for Public subnet.
resource "aws_route_table_association" "public" {
  count = "${var.public_subnet_count}"
  subnet_id = "${aws_subnet.public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

# NAT gateway elastic IPs
resource "aws_eip" "nat_gateway" {
  vpc = true
}

# NAT gateways
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.nat_gateway.id}"
  subnet_id = "${aws_subnet.public_subnet.*.id[0]}"
  depends_on = ["aws_internet_gateway.igw", "aws_eip.nat_gateway"]
}

# Private subnets
resource "aws_subnet" "private_subnet" {
  count = "${var.private_subnet_count}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.private_subnet_cidr[count.index]}"
  availability_zone = "${data.aws_availability_zones.available_zones.names[count.index]}"

  tags {
    Name = "${var.pre_tag}Private-${count.index + 1}"
    Environment = "${var.tag_environment}"
  }
}

# Private route tables
resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.pre_tag}Private"
    Environment = "${var.tag_environment}"
  }
}

# Attach 0/0 route to private route
resource "aws_route" "nat" {
  route_table_id = "${aws_route_table.private_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
}

# Route table association for Public subnet.
resource "aws_route_table_association" "private_atn" {
  count = "${var.private_subnet_count}"
  subnet_id = "${aws_subnet.private_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.private_rt.id}"
}


## To check if required
/*
 ECSIGVPCAssociation:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      InternetGatewayId: !Ref 'ECSInternetGateway'
      VpcId: !Ref 'EcsVpc'
 
  
  ECSNatRoute:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref 'ECSPrivateRouteTable'
      DestinationCidrBlock: 0.0.0.0/0
      NatGatewayId: !Ref 'NAT'
*/