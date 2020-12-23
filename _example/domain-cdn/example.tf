provider "aws" {
  region = "eu-west-1"
}

module "acm" {
  source  = "clouddrove/acm/aws"
  version = "0.14.0"

  name        = "certificate"
  repository  = "https://registry.terraform.io/modules/acm/s3/aws/0.14.0"
  environment = "test"
  label_order = ["name", "environment"]

  domain_name            = "clouddrove.com"
  validation_method      = "EMAIL"
  validate_certificate   = true
  enable_aws_certificate = true
}

module "cdn" {
  source = "./../../"

  name                   = "domain-cdn"
  repository             = "https://registry.terraform.io/modules/cdn/s3/aws/0.14.0"
  environment            = "test"
  label_order            = ["name", "environment"]
  custom_domain          = true
  compress               = false
  aliases                = ["clouddrove.com"]
  domain_name            = "clouddrove.com"
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn
}


