# Create IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${var.environment}-notify-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Create custom policy for DynamoDB access
resource "aws_iam_role_policy" "dynamodb_access" {
  name = "${var.project_name}-${var.environment}-dynamodb-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          var.dynamodb_table_arn,
          "${var.dynamodb_table_arn}/index/*"
        ]
      }
    ]
  })
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}-notify"
  retention_in_days = var.log_retention_days
}

# Create Lambda function
resource "aws_lambda_function" "notify" {
  filename         = var.lambda_source_path
  function_name    = "${var.project_name}-${var.environment}-notify"
  role            = aws_iam_role.lambda_role.arn
  handler         = "notify_lambda.handler"
  runtime         = var.runtime
  memory_size     = var.memory_size
  timeout         = var.timeout

  environment {
    variables = {
      ENVIRONMENT             = var.environment
      DYNAMODB_TABLE         = var.dynamodb_table_name
      LINE_CHANNEL_SECRET    = var.line_channel_secret
      LINE_CHANNEL_TOKEN     = var.line_channel_access_token
    }
  }

  reserved_concurrent_executions = var.reserved_concurrent_executions

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
    aws_iam_role_policy_attachment.lambda_basic
  ]
}

# Create Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notify.function_name
  principal     = "apigateway.amazonaws.com"
  # The source ARN will be updated when API Gateway is created
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*/*"
}

# Get current region and account ID
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
