# Configure provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.common_tags
  }
}

# Configure backend (commented out - user should configure according to their needs)
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "retail-crm/dev/terraform.tfstate"
#     region         = "ap-northeast-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#   }
# }

# DynamoDB Module
module "dynamodb" {
  source = "../../modules/dynamodb"

  environment  = var.environment
  project_name = var.project_name

  billing_mode = var.dynamodb_billing_mode
}

# Cognito Module
module "cognito" {
  source = "../../modules/cognito"

  environment  = var.environment
  project_name = var.project_name

  password_minimum_length = var.cognito_password_minimum_length
  mfa_enabled            = var.cognito_mfa_enabled
}

# Lambda Module
module "lambda" {
  source = "../../modules/lambda"

  environment  = var.environment
  project_name = var.project_name

  memory_size = var.lambda_memory_size
  timeout     = var.lambda_timeout

  # DynamoDB integration
  dynamodb_table_arn  = module.dynamodb.table_arn
  dynamodb_table_name = module.dynamodb.table_name

  # LINE API configuration
  line_channel_secret       = var.line_channel_secret
  line_channel_access_token = var.line_channel_access_token

  depends_on = [module.dynamodb]
}

# API Gateway Module
module "api_gateway" {
  source = "../../modules/api_gateway"

  environment  = var.environment
  project_name = var.project_name

  # Lambda integration
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.function_name

  # Cognito integration
  cognito_user_pool_arn = module.cognito.user_pool_arn

  # Stage configuration
  stage_name = var.api_stage_name

  depends_on = [module.lambda, module.cognito]
}
