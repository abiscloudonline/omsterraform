terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51"
    }
  }
}
provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}
resource "aws_vpc" "main" {                            #creation of VPC main
  cidr_block       = "${var.cidr}"
  instance_tenancy = "${var.tenancytype}"
  enable_dns_support   = "${var.dnsSupport}"
  enable_dns_hostnames = "${var.dnsHostNames}"

  tags = {
    Name = "main"
  }
}
resource "aws_subnet" "pub-subnets" {                   #creation of public subnet in VPC main
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${var.pubsubaz}"
  cidr_block              = "${var.pubsubcidr}"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-subnets"
  }
}

resource "aws_subnet" "private-subnets" {                #creation of private subnet in VPC main
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${var.prisubaz}"
  cidr_block              = "${var.prisubcidr}"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnets"
  }
}

resource "aws_internet_gateway" "i-gateway" {             #creation of internet gateway for VPC main
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "igtw"
  }
}

resource "aws_route_table" "pub-table" {                  #creation of public route table for public subnet
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "pub-route" {                         #associate public route table with internet gateway
  route_table_id         = "${aws_route_table.pub-table.id}"
  destination_cidr_block = "${var.acceptallcidr}"
  gateway_id             = "${aws_internet_gateway.i-gateway.id}"
}

resource "aws_route_table_association" "as-pub" {          # associate public subnet with public route table
  route_table_id = "${aws_route_table.pub-table.id}"
  subnet_id      = "${aws_subnet.pub-subnets.id}"
}

resource "aws_route_table" "pri-table" {                 #creation of private route table for private subnet
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table_association" "as-pri" {         # associate private subnet with private route table
  route_table_id = "${aws_route_table.pri-table.id}"
  subnet_id      = "${aws_subnet.private-subnets.id}"
}
resource "aws_eip" "elasticip" {                          #create elastic IP for NAT Gateway
  vpc      = true
}
resource "aws_nat_gateway" "NATforprivate" {              #creation of NAT Gateway
  allocation_id = aws_eip.elasticip.id
  subnet_id     = aws_subnet.pub-subnets.id
}
resource "aws_route" "pri-route" {                         #associate private route table with NAT gateway
  route_table_id         = "${aws_route_table.pri-table.id}"
  destination_cidr_block = "${var.acceptallcidr}"
  gateway_id             = "${aws_nat_gateway.NATforprivate.id}"
}
resource "aws_security_group" "publicsg" {                #creation of public security group for public subnet
  name        = "public security group"
  description = "Allows inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "enable SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "publicsg"
  }
}

resource "aws_security_group" "privatesg" {        #creation of private security group for private subnet
  name        = "private security group"
  description = "private security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "privatesg"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = ["${aws_security_group.publicsg.id}"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "privatesg"
  }
}
resource "aws_instance" "public" {                        #creation of public instance
  ami           = "${var.amiid}"
  instance_type = "${var.instancetype}"
  subnet_id = "${aws_subnet.pub-subnets.id}"
  vpc_security_group_ids = ["${aws_security_group.publicsg.id}"] 
  key_name = "${var.key_name}"

  tags = {
    Name = "public_instance"
  }
}
resource "aws_instance" "private" {                       #creation of private instance
  ami           = "${var.amiid}"
  instance_type = "${var.instancetype}"
  subnet_id = "${aws_subnet.private-subnets.id}"
  vpc_security_group_ids = ["${aws_security_group.privatesg.id}"]
  key_name = "${var.key_name}"

  tags = {
    Name = "private_instance"
  }
}
resource "aws_vpc_endpoint" "cloudwatch_endpoint" {      #creating vpc endpoint to access cloudwatch logs
  vpc_id       = aws_vpc.main.id
  service_name = "${var.svc_name}"
}
resource "aws_vpc_endpoint_route_table_association" "endptassociation" {  # associating private route table with endpoint to enable the access of cloudwatch in private subnet
  route_table_id  = aws_route_table.pri-table.id
  vpc_endpoint_id = aws_vpc_endpoint.cloudwatch_endpoint.id
}


resource "aws_vpn_gateway" "vpn_gateway"{              #creation of virtual private gateway for AWS Side
  vpc_id = aws_vpc.main.id
}
resource "aws_vpn_gateway_route_propagation" "main" {  #integeration of virtual private gateway with private route table
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
  route_table_id = aws_route_table.pri-table.id
}
resource "aws_customer_gateway" "customer_gateway" { #creation of customer gateway for Onprem Side
  bgp_asn    = "${var.bgpval}"
  ip_address = "${var.custip_addr}"   #  replace with your CGW IP address from network guy of on prem
  type       = "${var.custip_type}"
}
resource "aws_vpn_connection" "main" {                     # Enabling vpn gateway by integerating virtual private gateway & customer gateway
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  type                = "${var.custip_type}"
  static_routes_only  = true
}
