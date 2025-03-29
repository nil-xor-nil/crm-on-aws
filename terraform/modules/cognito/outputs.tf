output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.arn
}

output "user_pool_endpoint" {
  description = "Endpoint of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.endpoint
}

output "client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.main.id
}

output "domain" {
  description = "Domain name of the Cognito User Pool"
  value       = aws_cognito_user_pool_domain.main.domain
}

output "domain_aws_account_id" {
  description = "AWS account ID for the Cognito domain"
  value       = aws_cognito_user_pool_domain.main.aws_account_id
}

output "domain_cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution for the domain"
  value       = aws_cognito_user_pool_domain.main.cloudfront_distribution_arn
}

output "domain_s3_bucket" {
  description = "S3 bucket for the Cognito domain"
  value       = aws_cognito_user_pool_domain.main.s3_bucket
}
