provider "aws" {
  region = local.region
}

locals {
  region      = "us-east-1"
  name        = "cloudfront"
  environment = "test"
}

module "s3_bucket" {
  source  = "clouddrove/s3/aws"
  version = "2.0.0"

  name        = "${local.name}-secure-bucket-cdn"
  environment = local.environment
  versioning  = true
  acl         = "private"
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
  access_log_bucket      = module.s3_bucket.id
}


