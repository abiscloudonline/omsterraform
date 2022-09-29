variable "profile" {
  description = "AWS Profile"
  default     = "default"
}
variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}
variable "key_name" {
  description = "private key name"
  default     = "LinuxVir"
}
variable "pubsubaz" {
  type = list(string)
  default = "us-east-1a"
}
variable "prisubaz" {
  type = list(string)
  default = "us-east-1b"
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "tenancytype" {
  default = "default"
}
variable "cidr" {
    description = "CIDR range for VPC ID"
  default = "10.0.0.0/16"
}
variable "cidraccepter" {
    description = "CIDR of accepter vpc"
  default = "172.0.0.0/16"
}
variable "acceptallcidr" {
    description = "CIDR range to accept from all systems"
  default = "0.0.0.0/0"
}
variable "pubsubcidr" {
    description = "CIDR range for public subnet"
  default = "10.0.1.0/24"
}
variable "prisubcidr" {
    description = "CIDR range for private subnet"
  default = "10.0.2.0/24"
}
variable "amiid" {
    description = "ami id to be created"
  default = "ami-026b57f3c383c2eec"
}
variable "instancetype" {
    description = "type of instance"
  default = "t2.micro"
}
variable "svc_name" {
    description = "service name for cloudwatch logs"
  default = "com.amazonaws.us-east-1.logs"
}
variable "custip_addr" {
    description = "customer ip address"
  default = "134.72.x.x"
}
variable "custip_type" {
    description = "type of customer network"
  default = "ipsec.1"
}
variable "endpt_type" {
    description = "type of vpc endpoint"
  default = "Interface"
}
variable "bgpval" {
    description = "bgp value"
  default = "65000"
}
variable "requestor_vpc_id" {
  type        = string
  description = "Requestor VPC ID"
  default     = ""
}
variable "requestor_vpc_tags" {
  type        = map(string)
  description = "Requestor VPC tags"
  default     = {}
}

variable "requestor_route_table_tags" {
  type        = map(string)
  description = "Only add peer routes to requestor VPC route tables matching these tags"
  default     = {}
}

variable "acceptor_vpc_id" {
  type        = string
  description = "Acceptor VPC ID"
  default     = ""
}

variable "acceptor_vpc_tags" {
  type        = map(string)
  description = "Acceptor VPC tags"
  default     = {}
}

variable "acceptor_route_table_tags" {
  type        = map(string)
  description = "Only add peer routes to acceptor VPC route tables matching these tags"
  default     = {}
}

variable "auto_accept" {
  type        = bool
  default     = true
  description = "Automatically accept the peering (both VPCs need to be in the same AWS account)"
}

variable "acceptor_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow acceptor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requestor VPC"
}

variable "requestor_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow requestor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the acceptor VPC"
}
variable "accepter_profile" {
  description = "AWS Profile"
  default     = "default"
}

variable "owner_vpc_id" {
  description = "Owner VPC Id"
}

variable "accepter_vpc_id" {
  description = "Accepter VPC Id"
}
variable "owner_profile" {
  description = "AWS Profile"
  default     = "default"
}
