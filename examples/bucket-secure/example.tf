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

  name                 = "${local.name}-certificate"
  environment          = local.environment
  domain_name          = "clouddrove.com"
  validation_method    = "EMAIL"
  validate_certificate = false

}

module "cdn" {
  source = "./../../"

  name                   = "${local.name}-secure"
  environment            = local.environment
  enabled_bucket         = true
  compress               = false
  aliases                = ["clouddrove.com"]
  bucket_name            = module.s3_bucket.id
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn
  trusted_signers        = ["self"]
  public_key_enable      = true
  public_key             = "./cdn.pem"
  access_log_bucket      = module.s3_bucket.id

}


