data "aws_iam_policy_document" "apig_lambda_policy" {
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    effect    = "Allow"
    resources = [aws_lambda_function.authorizer_lambda.arn]
    sid       = "ApiGatewayInvokeLambda"
  }
}

data "aws_iam_policy_document" "apig_lambda_role_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "apig_lambda_role" {
  name               = "apigateway-authorize-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.apig_lambda_role_assume.json
}

resource "aws_iam_policy" "apig_lambda" {
  name   = "apig-lambda-policy"
  policy = data.aws_iam_policy_document.apig_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "apig_lambda_role_to_policy" {
  role       = aws_iam_role.apig_lambda_role.name
  policy_arn = aws_iam_policy.apig_lambda.arn
}


