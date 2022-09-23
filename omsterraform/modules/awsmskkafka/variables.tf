variable "profile" {
  description = "AWS Profile"
  default     = "default"
}
variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}
variable "env" {
  description = "environment"
  default     = "dev"
}
variable "cidrrange" {
  description = "cidr range for vpc"
  default     = "10.0.0.0/16"
}
variable "cidrrange1" {
  description = "cidr range for vpc"
  default     = "192.168.0.0/24"
}
variable "cidrrange2" {
  description = "cidr range for vpc"
  default     = "192.168.1.0/24"
}
variable "cidrrange3" {
  description = "cidr range for vpc"
  default     = "192.168.2.0/24"
}
variable "statusinfo" {
  description = "status of available zones"
  default     = "Available"
}
variable "ClusterName" {
  description = "cluster name"
  default     = "MSKCluster"
}
variable "InstanceType" {
  description = "Instance type"
  default     = "kafka.m5.large"
}
variable "amiid" {
  description = "ami value"
  default     = "ami-06489866022e12a14"
}
variable "key_name" {
  description = "private key name"
  default     = "Linuxkey"
}
variable "bucket" {
  description = "environment"
  default     = "Transferbucket"
}
variable "keyvalue" {
  description = "value for key"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbex+5IrL3UcuXerypur624Ushii5QgvSol6J6bsxRzkMmr1ma68maktXMxZyZPZL/EDN7tlfEIkplti6b9lFc1YRpy/OVThBbLn8IowbO4WZ5iaD/zWE1aIwnie5tNSBaYxYhziDtgObQxgtVKF/6Bg6frlm4boVy7pZlZKYtaJDDjCMqRBFe7Pb9AZeeEuhp3k+NoKmBl3uwUgTziF/Qyv4IEseOIMhOVgcogskn9mulh9yHMD3Ta4IuuqxjMOATgXZIzl4Ohyuf9qQhVc8jYfuCCqZe7/D+PBd2VutuI+kOH5YvpuCtxy+ec//uKaUISpVYTBC5xwo6LVRiiZl+1tKQRODYuc+Y52nsJEyO5ISW0D0tzRIv3MxmbjAgvbHfwYWlFDZOXeA1Ckc11+kvnr2rh+6Wqnje9hD4pNk7eeiK2HjgxAn4WznyyZA5wNPrQU07M/HgoKyqVXupmTTpIc5ehrraMsQ+VJ51zCZQbfDity8IC7xLDIIrreoDtj8="
}
variable "identityprovider" {
  description = "identityprovider name"
  default     = "SERVICE_MANAGED"
}
variable "user" {
  description = "user name for sftp"
  default     = "tftestuser"
}
variable "role" {
  description = "role name for sftp"
  default     = "sftprole"
}
variable "policy" {
  description = "policy name for sftp role"
  default     = "sftprolepolicy"
}
