provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source      = "clouddrove/s3/aws"
  version     = "0.14.0"
  name        = "secure-bucket-cdn"
  repository  = "https://registry.terraform.io/modules/clouddrove/s3/aws/0.14.0"
  environment = "test"
  label_order = ["name", "environment"]

  versioning     = true
  acl            = "private"
  bucket_enabled = true
}

module "acm" {
  source  = "clouddrove/acm/aws"
  version = "0.14.0"

  name        = "certificate"
  repository  = "https://registry.terraform.io/modules/acm/s3/aws/0.14.0"
  environment = "test"
  label_order = ["name", "environment"]

  domain_name          = "clouddrove.com"
  validation_method    = "EMAIL"
  validate_certificate = false

}

module "cdn" {
  source = "./../../"

  name                   = "secure-cdn"
  repository             = "https://registry.terraform.io/modules/cdn/s3/aws/0.14.0"
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


