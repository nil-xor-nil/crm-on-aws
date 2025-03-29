variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "retail-crm"
}

# DynamoDB Configuration
variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode"
  type        = string
  default     = "PAY_PER_REQUEST"
}

# Lambda Configuration
variable "lambda_memory_size" {
  description = "Memory size for Lambda function"
  type        = number
  default     = 128
}

variable "lambda_timeout" {
  description = "Timeout for Lambda function"
  type        = number
  default     = 30
}

# LINE API Configuration
variable "line_channel_secret" {
  description = "LINE Channel Secret"
  type        = string
  sensitive   = true
}

variable "line_channel_access_token" {
  description = "LINE Channel Access Token"
  type        = string
  sensitive   = true
}

# API Gateway Configuration
variable "api_stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "dev"
}

# Cognito Configuration
variable "cognito_password_minimum_length" {
  description = "Minimum length required for Cognito user passwords"
  type        = number
  default     = 8
}

variable "cognito_mfa_enabled" {
  description = "Whether to enable MFA for Cognito users"
  type        = bool
  default     = false
}

# Common Tags
variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "retail-crm"
    ManagedBy   = "terraform"
  }
}
