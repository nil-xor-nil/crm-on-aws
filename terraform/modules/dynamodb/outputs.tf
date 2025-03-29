output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.products.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.products.arn
}

output "table_id" {
  description = "ID of the DynamoDB table"
  value       = aws_dynamodb_table.products.id
}

output "category_index_name" {
  description = "Name of the category GSI"
  value       = "category-index"
}

output "stream_arn" {
  description = "ARN of the DynamoDB table stream"
  value       = aws_dynamodb_table.products.stream_arn
}
