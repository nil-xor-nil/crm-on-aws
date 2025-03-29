# DynamoDB Outputs
output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.dynamodb.table_arn
}

# Cognito Outputs
output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = module.cognito.client_id
}

output "cognito_user_pool_domain" {
  description = "Domain name of the Cognito User Pool"
  value       = module.cognito.domain
}

# Lambda Outputs
output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "lambda_log_group" {
  description = "CloudWatch Log Group for the Lambda function"
  value       = module.lambda.log_group_name
}

# API Gateway Outputs
output "api_endpoint" {
  description = "Endpoint URL of the API Gateway"
  value       = module.api_gateway.api_endpoint
}

output "api_stage_name" {
  description = "Name of the API Gateway stage"
  value       = module.api_gateway.stage_name
}

output "api_invoke_url" {
  description = "Base URL for invoking the API"
  value       = module.api_gateway.invoke_url
}

# Integration Information
output "integration_info" {
  description = "Important integration information for the frontend"
  value = {
    api_endpoint     = module.api_gateway.api_endpoint
    user_pool_id     = module.cognito.user_pool_id
    client_id        = module.cognito.client_id
    identity_pool_id = module.cognito.user_pool_id
    aws_region       = var.aws_region
  }
}

# Monitoring Information
output "monitoring_info" {
  description = "CloudWatch Log Groups for monitoring"
  value = {
    lambda_logs     = module.lambda.log_group_name
    api_logs        = module.api_gateway.log_group_name
  }
}
