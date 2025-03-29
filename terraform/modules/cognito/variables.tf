variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "password_minimum_length" {
  description = "Minimum length required for user passwords"
  type        = number
  default     = 8
}

variable "password_require_lowercase" {
  description = "Whether to require lowercase letters in passwords"
  type        = bool
  default     = true
}

variable "password_require_numbers" {
  description = "Whether to require numbers in passwords"
  type        = bool
  default     = true
}

variable "password_require_symbols" {
  description = "Whether to require symbols in passwords"
  type        = bool
  default     = true
}

variable "password_require_uppercase" {
  description = "Whether to require uppercase letters in passwords"
  type        = bool
  default     = true
}

variable "mfa_enabled" {
  description = "Whether to enable MFA for the user pool"
  type        = bool
  default     = false
}

variable "mfa_configuration" {
  description = "MFA configuration for the user pool. Valid values: OFF, ON, OPTIONAL"
  type        = string
  default     = "OFF"
}

variable "email_verification_message" {
  description = "Message template for email verification"
  type        = string
  default     = "Your verification code is {####}"
}

variable "email_verification_subject" {
  description = "Subject line for email verification"
  type        = string
  default     = "Your verification code"
}

variable "auto_verified_attributes" {
  description = "Attributes to be auto-verified (email)"
  type        = list(string)
  default     = ["email"]
}
