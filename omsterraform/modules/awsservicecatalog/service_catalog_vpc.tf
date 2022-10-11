resource "aws_servicecatalog_product" "sc_vpc" {              #creating a vpc product for service catalog
  name  = "${var.vpc_name}"
  owner = "${var.owner}"
  type  = "${var.type}"

  provisioning_artifact_parameters {
    template_url = "${var.url_vpc}"
    name = "${var.vpc_name}"
    type  = "${var.type}"
  }
}
resource "aws_servicecatalog_product_portfolio_association" "vpc_assoc" {   #associate product with the portfolio created
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  product_id   = aws_servicecatalog_product.sc_vpc.id
}
data "aws_servicecatalog_launch_paths" "vpcproductpath" {       #defining path for the product
  product_id = aws_servicecatalog_product.sc_vpc.id
}
resource "aws_servicecatalog_provisioned_product" "provisioned_vpc" {   #Configuring the product with artifact and path defined
  name                   = "${var.vpc_name}"
  product_id             = aws_servicecatalog_product.sc_vpc.id
  path_id                = data.aws_servicecatalog_launch_paths.vpcproductpath.summaries[0].path_id
  provisioning_artifact_name = aws_servicecatalog_product.sc_vpc.provisioning_artifact_parameters[0].name
}
