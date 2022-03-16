# all ec2 required resources:
# vpc, subnet,key,role,volume


data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ecs"]
  }
}


data "aws_subnet" "ecs_2a" {
  filter {
    name   = "tag:SELECTED"
    values = ["EKS_2a"]
  }
}

data "aws_subnet" "ecs_2b" {
  filter {
    name   = "tag:SELECTED"
    values = ["EKS_2b"]
  }
}

data "aws_eip" "jenkins_eip" {
  filter {
    name   = "tag:NAME"
    values = ["JENKINS"]
  }
}

data "aws_route53_zone" "async_hz" {
  name         = var.async_hz #the hostzone name "asyncworking.com"
  private_zone = false
}

data "aws_acm_certificate" "jenkins" {
  domain   = var.jenkins_domain #"cicd.asyncworking.com"
  types    = ["AMAZON_ISSUED"]
  statuses = ["ISSUED"]
}

