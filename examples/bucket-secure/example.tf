provider "aws" {
  region = local.region
}

locals {
  region      = "us-east-1"
  name        = "cloudfront"
  environment = "test"

  domain_name = "clouddrove.com"
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

  name                      = "${local.name}-certificate"
  environment               = local.environment
  domain_name               = "clouddrove.ca"
  subject_alternative_names = ["clouddrove.ca", "*.clouddrove.ca"]
  enable                    = true
  validation_method         = "DNS"
  validate_certificate      = true
}

module "cdn" {
  source = "./../../"

  name                   = "${local.name}-secure"
  environment            = local.environment
  cdn_enabled            = true
  compress               = false
  aliases                = ["clouddrove.ca", "www.clouddrove.ca"]
  bucket_name            = module.s3_bucket.id
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  trusted_signers        = ["self"]
  public_key_enable      = true
  public_key             = "./cdn.pem"

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  # logging_config = {
  #   bucket = module.s3_bucket.bucket_domain_name
  #   prefix = "cloudfront"
  # }

  origin = {
    s3_oac = { # with origin access control settings (recommended)
      domain_name           = module.s3_bucket.bucket_regional_domain_name
      origin_access_control = "s3_oac" # key in `origin_access_control`
      #      origin_access_control_id = "E345SXM82MIOSU" # external OAС resource
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_oac"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    use_forwarded_values = false

    cache_policy_id            = "b2884449-e4de-46a7-ac36-70bc7f1ddd6d"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "s3_oac"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]

      use_forwarded_values = false

      cache_policy_name            = "Managed-CachingOptimized"
      origin_request_policy_name   = "Managed-UserAgentRefererHeaders"
      response_headers_policy_name = "Managed-SimpleCORS"

      function_association = {
        # Valid keys: viewer-request, viewer-response
        viewer-request = {
          function_arn = aws_cloudfront_function.example.arn
        }

        viewer-response = {
          function_arn = aws_cloudfront_function.example.arn
        }
      }
    },
    {
      path_pattern           = "/static-no-policies/*"
      target_origin_id       = "s3_oac"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]

      # Using Cache/ResponseHeaders/OriginRequest policies is not allowed together with `compress` and `query_string` settings
      compress     = true
      query_string = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = module.acm.arn
    ssl_support_method  = "sni-only"
  }

  custom_error_response = [{
    error_code         = 404
    response_code      = 404
    response_page_path = "/errors/404.html"
    }, {
    error_code         = 403
    response_code      = 403
    response_page_path = "/errors/403.html"
  }]

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["NO", "UA", "US", "GB"]
  }

}

#########################################
# CloudFront function
#########################################

resource "aws_cloudfront_function" "example" {
  name    = "example-${local.name}-function"
  runtime = "cloudfront-js-1.0"
  code    = file("${path.module}/example-function.js")
}
