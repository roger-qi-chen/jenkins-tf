provider "aws" {
  region                  = var.aw_region     #var.aw_region
  shared_credentials_file = var.aws_credentials #var.aws_credentials
  profile                 = var.profile         #var.profile

}


resource "aws_acm_certificate" "jenkins_cert" {
  domain_name       = "cicd.asyncworking.com"
  validation_method = "DNS"

  tags = {
    ENV  = "UAT"
    TOOL = "TF"
    NAME = "JENKINS"
  }
  lifecycle {
    create_before_destroy = true
  }

}

data "aws_route53_zone" "async_hz" {
  name         = "asyncworking.com" #the hostzone name "asyncworking.com"
  private_zone = false
}

resource "aws_acm_certificate_validation" "jenkins_cert" {
  certificate_arn         = aws_acm_certificate.jenkins_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.jenkins_record : record.fqdn]
}

resource "aws_route53_record" "jenkins_record" {
  for_each = {
    for dvo in aws_acm_certificate.jenkins_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.async_hz.zone_id
}
/* 
resource "aws_route53_record" "jenkins_record_atype" {
  zone_id = data.aws_route53_zone.async_hz.zone_id
  name    = "cicd.asyncworking.com"
  type    = "A"

  alias {
    name                   = "dualstack.jenkins-alb-1427441714.ap-southeast-2.elb.amazonaws.com" #data.aws_alb.jenkins-alb.dns_name
    zone_id                = "Z1GM3OXH4ZPM65" #data.aws_alb.jenkins-alb.zone_id
    evaluate_target_health = true
  }
} */

/* data "aws_alb" "jenkins-alb" {
  /* filter {
    name   = "tag:NAME"
    values = ["JENKINS"] */
    
  /* } */
  /* depends_on = ["aws_alb.jenkins-alb"]  */
/* } * */
/* 
data "aws_alb" "jenkin-alb" {
    arn  = "arn:aws:elasticloadbalancing:ap-southeast-2:245866473499:loadbalancer/app/jenkins-alb/b30e6162974789f7"
    name = "jenkins-alb"
} */

/* variable "lb_arn" {
  type    = string
  default = "arn:aws:elasticloadbalancing:ap-southeast-2:245866473499:loadbalancer/app/jenkins-alb/b30e6162974789f7"
}

variable "lb_name" {
  type    = string
  default = "jenkins-alb" */
/* } */