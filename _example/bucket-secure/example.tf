provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source      = "clouddrove/s3/aws"
  version     = "1.3.0"
  name        = "secure-bucket-cdn"
  environment = "test"
  label_order = ["name", "environment"]

  versioning = true
  acl        = "private"
}

module "acm" {
  source  = "clouddrove/acm/aws"
  version = "1.4.1"

  name        = "certificate"
  environment = "test"
  label_order = ["name", "environment"]

  domain_name          = "clouddrove.com"
  validation_method    = "EMAIL"
  validate_certificate = false

}

module "cdn" {
  source = "./../../"

  name                   = "secure-cdn"
  environment            = "test"
  label_order            = ["name", "environment"]
  enabled_bucket         = true
  compress               = false
  aliases                = ["clouddrove.com"]
  bucket_name            = module.s3_bucket.id
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn

  trusted_signers   = ["self"]
  public_key_enable = true
  public_key        = "./cdn.pem"
}


