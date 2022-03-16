resource "aws_route53_record" "jenkins_record_atype" {
  zone_id = data.aws_route53_zone.async_hz.zone_id
  name    = var.jenkins_domain #cicd.asyncworking.com"
  type    = "A"

  alias {
    #name                   = "jenkins-alb-1028719094.ap-southeast-2.elb.amazonaws.com" 
    name = aws_alb.jenkins-alb.dns_name #aws_alb.jenkins-alb.dns_name #
    #zone_id                = "Z1GM3OXH4ZPM65"   
    zone_id = aws_alb.jenkins-alb.zone_id #  #data.aws_alb.jenkins-alb.zone_id
    evaluate_target_health = true
  }
}

/* data "aws_alb" "jenkins-alb" {
  name = module.alb 
  depends_on = [aws_alb.jenkins-alb] 
}   */