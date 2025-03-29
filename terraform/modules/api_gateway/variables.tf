variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  type        = string
}

variable "stage_name" {
  description = "Name of the deployment stage"
  type        = string
  default     = "dev"
}

variable "cors_allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allowed_methods" {
  description = "List of allowed HTTP methods for CORS"
  type        = list(string)
  default     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
}

variable "cors_allowed_headers" {
  description = "List of allowed headers for CORS"
  type        = list(string)
  default     = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token"]
}

variable "cors_expose_headers" {
  description = "List of exposed headers for CORS"
  type        = list(string)
  default     = ["Content-Type", "X-Amz-Date", "X-Amz-Security-Token"]
}

variable "cors_max_age" {
  description = "Time in seconds that browser can cache preflight request results"
  type        = number
  default     = 7200
}

variable "throttling_rate_limit" {
  description = "API Gateway throttling rate limit"
  type        = number
  default     = 10000
}

variable "throttling_burst_limit" {
  description = "API Gateway throttling burst limit"
  type        = number
  default     = 5000
}

variable "metrics_enabled" {
  description = "Whether to enable API Gateway metrics"
  type        = bool
  default     = true
}

variable "logging_level" {
  description = "API Gateway logging level (OFF, INFO, ERROR)"
  type        = string
  default     = "INFO"
}
