terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51"
    }
  }
}
provider "aws" {                     #Cloud provider information
  profile = "${var.profile}"
  region  = "${var.region}"
}
resource "aws_vpc" "vpc" {           #VPC information
  cidr_block = "${var.cidrrange}"
}

data "aws_availability_zones" "azs" { #Availability information
  state = "${var.statusinfo}"
}

resource "aws_subnet" "subnet_az1" {                             #Creating subnet 1 for broker 1
  availability_zone = data.aws_availability_zones.azs.names[0]
  cidr_block        = "${var.cidrrange1}"
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_az2" {                              #Creating subnet 2 for broker 2
  availability_zone = data.aws_availability_zones.azs.names[1]
  cidr_block        = "${var.cidrrange2}"
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_az3" {                              #Creating subnet 3 for broker 3
  availability_zone = data.aws_availability_zones.azs.names[2]
  cidr_block        = "${var.cidrrange3}"
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_security_group" "sg" {                             #Creating security group
  vpc_id = aws_vpc.vpc.id
}

resource "aws_kms_key" "kms" {                                   #Creating kms key
  description = "kms_key"
}

resource "aws_iam_role" "cluster_role" {                        #Creating IAM role
  name = "${var.role}"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "firehose.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }
  ]
}
EOF
}
resource "aws_msk_cluster" "MSKCluster" {                       #creating MSK cluster
  cluster_name           = "${var.clusterName}"
  kafka_version          = "3.2.0"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type =   "${var.instancetype}"                                           #"kafka.m5.large"
    client_subnets = [
      aws_subnet.subnet_az1.id,
      aws_subnet.subnet_az2.id,
      aws_subnet.subnet_az3.id,
    ]
    security_groups = [aws_security_group.sg.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }

}
output "zookeeper_connect_string" {                              #creating zookeepr for managing the brokers
  value = aws_msk_cluster.MSKCluster.zookeeper_connect_string
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.MSKCluster.bootstrap_brokers_tls
}

resource "aws_instance" "kafka-server" {                        #Creating client machine for producer and consumer
    ami                 = "${var.amiid}"
    instance_type       = "${var.instancetype}"
    count               = 1
    key_name            = "${var.key_name}"
    security_groups     = ["${aws_security_group."${var.securitygroup}".name}"]
    tags = {
    Name = "Client-Machine"
    }
}
