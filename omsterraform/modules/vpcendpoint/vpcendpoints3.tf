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
resource "aws_vpc" "main" {                                     #creating VPC
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = "${var.dnsSupport}"
  enable_dns_hostnames = "${var.dnsHostNames}"

  tags = {
    Name = "main"
  }
}
resource "aws_subnet" "pub-subnets" {                       #creation of public subnet in VPC main
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "ap-south-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-subnets"
  }
}

resource "aws_subnet" "private-subnets" {                  #creation of private subnet in VPC main
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "ap-south-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnets"
  }
}

resource "aws_internet_gateway" "i-gateway" {                   #creation of internet gateway for VPC main
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "igtw"
  }
}

resource "aws_route_table" "pub-table" {                     #creation of public route table for public subnet
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "pub-route" {                                #associate public route table with internet gateway
  route_table_id         = "${aws_route_table.pub-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.i-gateway.id}"
}

resource "aws_route_table_association" "as-pub" {            # associate public subnet with public route table
  route_table_id = "${aws_route_table.pub-table.id}"
  subnet_id      = "${aws_subnet.pub-subnets.id}"
}
resource "aws_route_table" "pri-table" {               #creation of private route table for private subnet
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table_association" "as-pri" {             # associate private subnet with private route table
  route_table_id = "${aws_route_table.pri-table.id}"
  subnet_id      = "${aws_subnet.private-subnets.id}"
}

resource "aws_security_group" "publicsg" {                 #creation of public security group for public subnet
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

resource "aws_security_group" "privatesg" {               #creation of private security group for private subnet
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
resource "aws_s3_bucket" "vpctestbucket" {          #creation of s3 bucket to test from private network   
  bucket = "vpctestbucket3009"

  tags = {
    Name        = "My bucket"
    Environment = "VPC_Endpoint_test"
  }
}

resource "aws_s3_bucket_acl" "vpctestbucket_acl" {         #permission for s3 bucket
  bucket = aws_s3_bucket.vpctestbucket.id
  acl    = "private"
}

resource "aws_vpc_endpoint" "s3" {                       #creation of vpc endpoint
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"
}
resource "aws_vpc_endpoint_route_table_association" "endptasso" {        #vpc endpoint association with private route table
  route_table_id  = aws_route_table.pri-table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
resource "aws_instance" "public" {                                #creation of public instance
  ami           = "ami-026b57f3c383c2eec" # ap-south-1
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.pub-subnets.id}"
  vpc_security_group_ids = ["${aws_security_group.publicsg.id}"]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name 
  key_name = "${var.key_name}"

  tags = {
    Name = "public_instance"
  }
}
resource "aws_instance" "private" {                            #creation of private instance
  ami           = "ami-026b57f3c383c2eec" # ap-south-1 us-east-1 ami-026b57f3c383c2eec
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private-subnets.id}"
  vpc_security_group_ids = ["${aws_security_group.privatesg.id}"]
  key_name = "${var.key_name}"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name 

  tags = {
    Name = "private_instance"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {                #creation of IAM role
  name = "test_profile"
  role = aws_iam_role.example.name
}

resource "aws_iam_role" "example" {
  name = "tf-test-transfer-user-iam-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "example" {          #creation of iam policy
  name = "tf-test-transfer-user-iam-policy"
  role = aws_iam_role.example.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowFullAccesstoS3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "policy" {                      #creation of iam policy
  name        = "ec2_S3policy"
  description = "Access to s3 policy from ec2"
  policy      = <<EOF
{
 "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": "s3:*",
           "Resource": "*"
       }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-attach" { #role policy attachment
  role     = aws_iam_role.example.name
  policy_arn = aws_iam_policy.policy.arn
}
