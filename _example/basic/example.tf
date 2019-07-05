provider "aws" {
  region = "us-east-1"
}
module "s3_bucket" {
  source = "git::https://github.com/clouddrove/terraform-aws-s3.git"

  name        = "secure-bucket-cdn"
  region      = "us-east-1"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  versioning     = true
  acl            = "private"
  bucket_enabled = true
}

module "acm" {
  source = "git::https://github.com/clouddrove/terraform-aws-acm.git"

  name        = "certificate"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  domain_name          = "clouddrove.com"
  validation_method    = "EMAIL"
  validate_certificate = true
}

module "cdn" {
  source = "git::https://github.com/clouddrove/terraform-aws-cloudfront-cdn.git"

  name        = "basic-cdn"
  application = "clouddrove"
  label_order = ["environment", "name", "application"]

  environment            = "test"
  aliases                = ["clouddrove.com"]
  bucket_name            = module.s3_bucket.s3_default_id[0]
  viewer_protocol_policy = "redirect-to-https"
  compress               = "false"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn[0]
}


