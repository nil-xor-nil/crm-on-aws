resource "aws_dynamodb_table" "products" {
  name           = "${var.project_name}-${var.environment}-products"
  billing_mode   = var.billing_mode
  hash_key       = "product_id"
  
  # Only set capacity if billing mode is PROVISIONED
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  # Primary key
  attribute {
    name = "product_id"
    type = "S"
  }

  # GSI for category queries
  attribute {
    name = "category"
    type = "S"
  }

  global_secondary_index {
    name               = "category-index"
    hash_key           = "category"
    projection_type    = "ALL"
    read_capacity      = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
    write_capacity     = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  }

  # Enable point-in-time recovery
  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  # Enable server-side encryption
  server_side_encryption {
    enabled = true
  }

  # Add TTL for future use if needed
  ttl {
    enabled        = false
    attribute_name = "ttl"
  }

  lifecycle {
    prevent_destroy = true
  }
}
