provider "aws" {
  region  = "${var.region}"
}
resource "aws_servicecatalog_portfolio" "portfolio" {     #creating service catalog portfolio in us-east-1
  name          = "${var.portfolio_name}"
  description   = "${var.description}"
  provider_name = "${var.owner}"
}
resource "aws_servicecatalog_principal_portfolio_association" "associate_role" {  #associate role arn with the portfolio created
  portfolio_id  = aws_servicecatalog_portfolio.portfolio.id
  principal_arn = "${var.portfolio_role_arn}"
}
resource "aws_servicecatalog_portfolio_share" "portfolio_share" {  #sharing the access of sc products with account 614982824857
  principal_id = "${var.shareacc_id}"
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  type         = "${var.shareacc_type}"
}
