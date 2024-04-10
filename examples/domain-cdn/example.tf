provider "aws" {
  region = local.region
}

locals {
  region      = "us-east-1"
  name        = "cloudfront"
  environment = "test"
}

module "acm" {
  source  = "clouddrove/acm/aws"
  version = "1.4.1"

  name                   = "${local.name}-certificate"
  environment            = local.environment
  domain_name            = "api.clouddrove.ca"
  validation_method      = "EMAIL"
  validate_certificate   = true
  enable_aws_certificate = true
}


module "cdn" {
  source = "./../../"

  name                   = "${local.name}-domain"
  environment            = local.environment
  custom_domain          = true
  compress               = false
  aliases                = ["clouddrove.ca"]
  domain_name            = "clouddrove.ca"
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn
}


