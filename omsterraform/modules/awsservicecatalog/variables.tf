variable "profile" {
  description = "AWS Profile"
  default     = "default"
}
variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}
variable "owner" {
  description = "Owner of the Product"
  default     = "Abinaya"
}
variable "vpc_name" {
  description = "Name of the VPC"
  default     = "sc_vpc"
}
variable "type" {
  description = "Template format"
  default     = "CLOUD_FORMATION_TEMPLATE"
}
variable "url_vpc" {
  description = "url of the Template created"
  default     = "https://testbucket2409ny.s3.amazonaws.com/cf_template_vpc_sgcheck.yaml"
}
variable "portfolio_name" {
  description = "Name of the portfolio"
  default     = "MyAppPortfolio"
}
variable "description" {
  description = "description of the portfolio"
  default     = "List of my organizations apps"
}
variable "portfolio_role_arn" {
  description = "Role for the portfolio"
  default     = "arn:aws:iam::458819240932:role/codebuild-role"
}
variable "ecs_role_name" {
  description = "Name of the ECS role"
  default     = "SC_ECS_role"
}
variable "url_ecsrole" {
  description = "url of the Template created"
  default     = "https://testbucket2409ny.s3.amazonaws.com/demo_ecs.yaml"
}
variable "shareacc_id" {
  description = "ID of the share account"
  default     = "614982824857"
}
variable "shareacc_type" {
  description = "Type of the account"
  default     = "ACCOUNT"
}
