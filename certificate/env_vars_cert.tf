variable "aws_credentials" {
  type        = string
  description = "the aws credential path in your local environment"

}

variable "profile" {
  type        = string
  description = "aws credentials profile to choose"

}

variable "aw_region" {
  type        = string
  description = "choose region to deploy VM"

}