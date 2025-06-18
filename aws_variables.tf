# declare provider info for aws api access

variable "aws_region" {
  type = string
}

variable "aws_access_key" {
  type        = string
  description = "AWS API admin access key"
  sensitive   = true
}
variable "aws_secret_key" {
  type        = string
  description = "AWS API admin secret key"
  sensitive   = true
}
