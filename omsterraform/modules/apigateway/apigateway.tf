resource "aws_api_gateway_rest_api" "rest_api" {    ##Creating the Rest API Gateway
  name        = rest_api
  description = rest api description
}

resource "aws_api_gateway_resource" "check_in_resource" {  ## Resource creation for the API
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "${var.rest_api_path}"
}

resource "aws_api_gateway_method" "check_in_api_method" {   ## Creating the Method such put, get etc
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.check_in_resource.id
  http_method   = "GET" 
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_api_gateway_integration" "check_in_api_integration" {   ## Creating the intergration of the service and its method
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.check_in_resource.id
  http_method             = aws_api_gateway_method.check_in_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.welcome_check_in_message_lambda.invoke_arn ## URL of the lambda or the function
}

resource "aws_api_gateway_method_response" "check_in_method_response" {  ## Creating the Method Response for the method
  for_each    = toset(var.api_status_response)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.check_in_resource.id
  http_method = aws_api_gateway_method.check_in_api_method.http_method
  status_code = each.value
}

resource "aws_api_gateway_deployment" "api_deployment"{   ## To deploy the API Gateway
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.rest_api.body))
  }
}
resource "aws_api_gateway_authorizer" "api_authorizer" {   ## Authorizing the user with the help of Coginto User Pools
  name                        = "CognitoUserPoolAuthorizer"
  type                        = "COGNITO_USER_POOLS"
  rest_api_id                 = aws_api_gateway_rest_api.rest_api.id
  provider_arns               = [var.cognito_user_arn]
  authorizer_credentials_arn  = aws_iam_role.apig_lambda_role.arn 
}


output "invoke_arn" {value = "${aws_api_gateway_deployment.api_deployment.invoke_url}"}
output "path_part" {value = "${aws_api_gateway_resource.check_in_resource.path_part}"}
