resource "aws_cognito_user_pool" "main" {
  name = "${var.project_name}-${var.environment}-user-pool"

  # Username configuration
  username_attributes      = ["email"]
  auto_verified_attributes = var.auto_verified_attributes

  # Password policy
  password_policy {
    minimum_length                   = var.password_minimum_length
    require_lowercase                = var.password_require_lowercase
    require_numbers                  = var.password_require_numbers
    require_symbols                  = var.password_require_symbols
    require_uppercase                = var.password_require_uppercase
    temporary_password_validity_days = 7
  }

  # MFA configuration
  mfa_configuration = var.mfa_configuration

  # Email configuration
  verification_message_template {
    default_email_option  = "CONFIRM_WITH_CODE"
    email_message        = var.email_verification_message
    email_subject        = var.email_verification_subject
  }

  # Email sender configuration
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # Advanced security
  user_pool_add_ons {
    advanced_security_mode = "OFF"
  }

  # Schema attributes
  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable            = true
    required           = true
    string_attribute_constraints {
      min_length = 3
      max_length = 255
    }
  }

  # Account recovery
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

# User pool client
resource "aws_cognito_user_pool_client" "main" {
  name = "${var.project_name}-${var.environment}-client"

  user_pool_id = aws_cognito_user_pool.main.id

  # OAuth configuration
  generate_secret = false
  
  # Auth flows
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  # Token validity
  refresh_token_validity = 30
  access_token_validity  = 1
  id_token_validity     = 1

  token_validity_units {
    refresh_token = "days"
    access_token  = "hours"
    id_token      = "hours"
  }

  # Security configuration
  prevent_user_existence_errors = "ENABLED"
  enable_token_revocation      = true
}

# Domain name for the Cognito hosted UI (optional)
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.project_name}-${var.environment}"
  user_pool_id = aws_cognito_user_pool.main.id
}
