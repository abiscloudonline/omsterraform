resource "aws_servicecatalog_product" "SC_ECS_role" {              #creating a product ECS role for service catalog
  name  = "${var.ecs_role_name}"
  owner = "${var.owner}"
  type  = "${var.type}"

  provisioning_artifact_parameters {
    template_url = "${var.url_ecsrole}"
    name = "${var.ecs_role_name}"
    type  = "${var.type}"
  }
}
resource "aws_servicecatalog_product_portfolio_association" "ECS_role_assoc" {   #associate product with the portfolio created
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  product_id   = aws_servicecatalog_product.SC_ECS_role.id
}
data "aws_servicecatalog_launch_paths" "SC_ECS_role_productpath" {       #defining path for the product
  product_id = aws_servicecatalog_product.SC_ECS_role.id
}
resource "aws_servicecatalog_provisioned_product" "provisioned_ECS" {   #Configuring the product with artifact and path
  name                   = "${var.ecs_role_name}"
  product_id             = aws_servicecatalog_product.SC_ECS_role.id
  path_id                = data.aws_servicecatalog_launch_paths.SC_ECS_role_productpath.summaries[0].path_id
  provisioning_artifact_name = aws_servicecatalog_product.SC_ECS_role.provisioning_artifact_parameters[0].name
}
