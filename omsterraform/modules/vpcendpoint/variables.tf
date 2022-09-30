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
variable "azs" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
