provider "aws" {
  region                  = var.aw_region
  shared_credentials_file = var.aws_credentials
  profile                 = var.profile

}