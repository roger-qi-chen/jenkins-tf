variable "ssh_key" {
  type        = string
  default     = ""
  description = "my ssh key for jenkins"
}

variable "instance_tags" {
  type = object({
    NAME   = string
    TOOL   = string
    CREATE = string
  })

  description = "added tag:CREATE to resources"

}

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

variable "aw_ami" {
  type        = string
  description = "ami images to choose"
}

variable "aw_az" {
  type    = string
  default = "ap-southeast-2a"

}

variable "jenkins_domain" {
  type = string
  description = "jenkins server doimain in host zone"
}

variable "async_hz" {
  type = string
  
}