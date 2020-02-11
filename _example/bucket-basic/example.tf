provider "aws" {
  region = "us-east-1"
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
  source = "./../../"

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