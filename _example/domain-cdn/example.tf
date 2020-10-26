provider "aws" {
  region = "eu-west-1"
}

module "acm" {
  source  = "clouddrove/acm/aws"
  version = "0.13.0"

  name        = "certificate"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  domain_name            = "clouddrove.com"
  validation_method      = "EMAIL"
  validate_certificate   = true
  enable_aws_certificate = true
}

module "cdn" {
  source = "./../../"

  name        = "domain-cdn"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  custom_domain          = true
  compress               = false
  aliases                = ["clouddrove.com"]
  domain_name            = "clouddrove.com"
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn
}


