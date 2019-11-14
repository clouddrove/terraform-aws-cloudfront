provider "aws" {
  region = "eu-west-1"
}

module "acm" {
  source = "git::https://github.com/clouddrove/terraform-aws-acm.git?ref=tags/0.12.0"

  name        = "certificate"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  domain_name          = "clouddrove.com"
  validation_method    = "EMAIL"
  validate_certificate = true
}

module "cdn" {
  source = "git::https://github.com/clouddrove/terraform-aws-cloudfront-cdn.git?ref=tags/0.12.0"

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


