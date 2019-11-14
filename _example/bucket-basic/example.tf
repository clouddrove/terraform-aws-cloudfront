provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "git::https://github.com/clouddrove/terraform-aws-s3.git?ref=tags/0.12.2"

  name        = "basic-bucket-cdn"
  region      = "us-east-1"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  versioning     = true
  acl            = "private"
  bucket_enabled = true
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

  name        = "basic-cdn"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  enabled_bucket         = true
  compress               = false
  aliases                = ["clouddrove.com"]
  bucket_name            = module.s3_bucket.id
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn
}