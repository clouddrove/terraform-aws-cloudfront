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

  name                    = "${local.name}-basic-bucket-cdn"
  environment             = local.environment
  versioning              = true
  acl                     = "private"
  bucket_policy           = true
  aws_iam_policy_document = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  version = "2012-10-17"
  statement {
    sid    = "1"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity xxxxxxxxxxxxx"]
    }
    actions   = ["s3:GetObject"]
    resources = [format("%s/*", module.s3_bucket.arn)]
  }
}

module "acm" {
  source  = "clouddrove/acm/aws"
  version = "1.4.1"

  name                   = "${local.name}-certificate"
  environment            = local.environment
  domain_name            = "clouddrove.com"
  validation_method      = "EMAIL"
  validate_certificate   = true
  enable_aws_certificate = true
}

module "cdn" {
  source = "./../../"

  name                   = "${local.name}-basic"
  environment            = local.environment
  enabled_bucket         = true
  compress               = false
  aliases                = ["clouddrove.com"]
  bucket_name            = module.s3_bucket.id
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn
}