variable "allowed_oauth_flows" {
  type        = "list"
  description = "List of allowed OAuth flows (code, implicit, client_credential)"
  default     = []
}

variable "allowed_oauth_flows_user_pool_client" {
  type        = "string"
  description = "Whether the client is allowed to follow the OAuth protocol whe interacting with Cognito User Pool (true or false)"
  default     = "true"
}

variable "allowed_oauth_scopes" {
  type        = "list"
  description = "List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito,signin.user.admin)"
  default     = []
}

variable "callback_urls" {
  type        = "list"
  description = "List of allowed callback URLs for the identity prpviders"
  default     = []
}

variable "default_redirect_uri" {
  type        = "string"
  description = "The default redirect URI. Must be in the list of callback URLs"
  default     = ""
}

variable "explicit_auth_flows" {
  type         = "list"
  description = "List of authentication flows (ADMIN_NO_SRP_AUTH, CUSTOM_AUTH_FLOW_ONLY, USER_PASSWORD_AUTH)"
  default      = []
}

variable "generate_secret" {
  type        = "string"
  description = "Should be an application secret be generated (true or false)"
  default     = ""
}

variable "logout_urls" {
  type        = "list"
  description = "List of allowed logout URLs for the identity providers"
  default     = []
}

variable "name" {
  type        = "string"
  description = "The name of the application client" 
}

variable "user_name" {
  type        = "string"
  description = "The name of the application client" 
}

variable "read_attributes" {
  type        = "list"
  description = "List of user pool attributes the application client can read from"
  default     = []
}

variable "refresh_token_validity" {
  type        = "string"
  description = "The time limit in days refresh tokens are valid for"
  default     = ""
}

variable "supported_identity_providers" {
  type        = "list"
  description = "List of provider names for the identity providers that are supported on this client"
  default     = []
}

variable "user_pool_id" {
  type        = "string"
  description = "The user pool the client belongs to"
}

variable "write_attributes" {
  type        = "list"
  description = "List of user pool attributes the application client ca write to"
  default     = []
}

variable "user_pool_id" {
  type        = "string"
  description = "The user pool id"
}

variable "provider_name" {
  type        = "string"
  description = "The provider name"
}

variable "provider_type" {
  type        = "string"
  description = "The provider type"
}

variable "attribute_mapping" {
  type        = "map"
  description = "The map of attribute mapping of user pool attributes."
  default     = {}
}

variable "idp_identifiers" {
  type        = "list"
  description = "The list of identity providers."
  default     = []
}

variable "provider_details" {
  type        = "map"
  description = "The map of identity details, such as access token"
  default     = {}
}


variable "identity_pool_name" {
  type        = "string"
  description = "The cognito identity pool name"
}

variable "allow_unauthenticated_identities" {
  type        = "string"
  description = "Whether the identity pool supports unauthenticated logins or not.(true or false)"
}

variable "developer_provider_name" {
  type        = "string"
  description = "The domain by which Cognito will refer to your users. This name acts as a placeholder that allows your backend and the Cognito service to communicate about the developer provider."
  default     = ""
}

variable "cognito_identity_providers" {
  type        = "map"
  description = "An array of Amazon Cognito Identity user pools and their client IDs."
  default     = {}
}

variable "openid_connect_provider_arns" {
  type        = "list"
  description = "A list of OpendID Connect provider ARNs."
  default     = []
}

variable "saml_provider_arns" {
  type        = "list"
  description = "An array of Amazon Resource Names (ARNs) of the SAML provider for your identity."
  default     = []
}

variable "supported_login_providers" {
  type        = "map"
  description = "Key-Value pairs mapping provider names to provider app IDs."
  default     = {}
}

###Cognito Identity Providers

variable "client_id" {
  type        = "string"
  description = "The client ID for the Amazon Cognito Identity User Pool."
  default     = ""
}

variable "identity_name" {
  type        = "string"
  description = "The provider name for an Amazon Cognito Identity User Pool."
  default     = ""
}

variable "server_side_token_check" {
  type        = "string"
  description = "Whether server-side token validation is enabled for the identity provider’s token or not.(true or false)" 
  default     = ""
}

variable "rest_api_name" {
  type        = "string"
  description = "The name of the rest api gateway" 
}

variable "rest_api_description" {
  type        = "string"
  description = "The description of the rest api gateway" 
}

variable "rest_api_path" {
  type        = "string"
  description = "The path to create the resource in the rest_api" 
}


