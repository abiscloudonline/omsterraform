resource "aws_cognito_user_pool" "stellantis_user_pool" {   ## Creating the Cognito User Pool and the policy
  name = "${var.user_name}"

  email_verification_subject = "Your Verification Code"
  email_verification_message = "Please use the following code: {####}"
  alias_attributes           = ["email"]
  auto_verified_attributes   = ["email"]

  password_policy {
    minimum_length    = 6
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_configuration {
    case_sensitive = false
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 7
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true

    string_attribute_constraints {
      min_length = 3
      max_length = 256
    }
  }
}


resource "aws_cognito_user_pool_client" "client" {  ## Creating the Client User Pool to store the data of the client
  name = "${var.name}"
  user_pool_id = "${var.user_pool_id}"
  generate_secret                      = "${var.generate_secret}"
  explicit_auth_flows                  = ["${var.explicit_auth_flows}"]
  read_attributes                      = "${var.read_attributes}"
  write_attributes                     = "${var.write_attributes}"
  supported_identity_providers         = "${var.supported_identity_providers}"
  callback_urls                        = "${var.callback_urls}"
  logout_urls                          = "${var.logout_urls}"
  allowed_oauth_flows                  = "${var.allowed_oauth_flows}"
  refresh_token_validity               = "${var.refresh_token_validity}"
  allowed_oauth_flows_user_pool_client = "${var.allowed_oauth_flows_user_pool_client}"
  allowed_oauth_scopes                 = "${var.allowed_oauth_scopes}"
}

resource "aws_cognito_identity_provider" "example_provider" {  ## Creating the identity provider
  user_pool_id      = "${var.user_pool_id}"
  provider_name     = "${var.provider_name}"
  provider_type     = "${var.provider_type}"
  provider_details  = "${var.provider_details}"
  attribute_mapping = "${var.attribute_mapping}"
}

resource "aws_cognito_identity_pool" "main" {     ## Creating the identity pool
  identity_pool_name               = "${var.identity_pool_name}"
  allow_unauthenticated_identities = "${var.allow_unauthenticated_identities}"
  cognito_identity_providers {
    client_id               = "${var.client_id}"
    provider_name           = "${var.identity_name}"
    server_side_token_check = "${var.server_side_token_check}"
  }
}


