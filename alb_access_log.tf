

/* module "s3_bucket_for_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "alb-access-log-jenkins"
  acl    = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true

  attach_elb_log_delivery_policy = true
} */
 
/* 
resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-acess-log-jenkins"
  acl    = "log-delivery-write"
  tags   = var.instance_tags
}  */

/* 
resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-acess-log-jenkins"
  acl    = "log-delivery-write"
  tags   = var.instance_tags

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::783225319266:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::alb-access-log-jenkins/*"
        }
    ]
}
POLICY
}  */