provider "aws" {
  region = local.region
}

locals {
  region      = "eu-west-1"
  name        = "cloudfront"
  environment = "test"

  domain_name = "ld.clouddrove.ca"
}

module "acm" {
  source  = "clouddrove/acm/aws"
  version = "1.4.1"

  name                      = "${local.name}-cdn-certificate"
  environment               = local.environment
  domain_name               = local.domain_name
  enable                    = true
  validation_method         = "DNS"
  subject_alternative_names = ["*.clouddrove.ca"]
  # validate_certificate   = true
  # enable_aws_certificate = true
  # enable_dns_validation = true
}

module "cdn" {
  source = "./../../"

  name                   = "${local.name}-domain"
  environment            = local.environment
  compress               = false
  aliases                = [local.domain_name]
  domain_name            = local.domain_name
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = module.acm.arn


  origin = {
    appsync = {
      domain_name = "appsync.${local.domain_name}"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }

      custom_header = [
        {
          name  = "X-Forwarded-Scheme"
          value = "https"
        },
        {
          name  = "X-Frame-Options"
          value = "SAMEORIGIN"
        }
      ]

      origin_shield = {
        enabled              = true
        origin_shield_region = local.region
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "appsync"
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
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]

      use_forwarded_values = false

      cache_policy_name            = "Managed-CachingOptimized"
      origin_request_policy_name   = "Managed-UserAgentRefererHeaders"
      response_headers_policy_name = "Managed-SimpleCORS"
    }
  ]
}
