variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "retail-crm"
}

# Common variables that might be used across multiple modules
variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "resource_prefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = ""
}
