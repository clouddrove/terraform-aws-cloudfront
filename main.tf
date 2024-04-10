## Managed By : CloudDrove
## Description : This Script is used to create Origin Access Identity, Aws Cloudfront Distribution, Aws Cloudfront Public Key.
## Copyright @ CloudDrove. All Right Reserved.

#Module      : label
#Description : This terraform module is designed to generate consistent label names and
#              tags for resources. You can use terraform-labels to implement a strict
#              naming convention.
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"

  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

# Module      : CLOUDFRONT ORIGIN ACCESS IDENENTITY
# Description : Creates an Amazon CloudFront origin access identity
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  count   = var.cdn_enabled == true && var.enabled_bucket == true ? 1 : 0
  comment = format("access-identity-%s.s3.amazonaws.com", var.bucket_name)
}

locals {
  s3_origin_id = var.bucket_name
}

# Module      : CLOUDFRONT DISTRIBUSTION
# Description : Creates an Amazon CloudFront web distribution
#tfsec:ignore:aws-cloudfront-use-secure-tls-policy
#tfsec:ignore:aws-cloudfront-enable-waf
resource "aws_cloudfront_distribution" "bucket" {
  count = var.cdn_enabled == true && var.enabled_bucket == true ? 1 : 0

  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  price_class         = var.price_class
  aliases             = var.aliases
  default_root_object = var.default_root_object

  origin {
    domain_name = format("%s.s3.amazonaws.com", var.bucket_name)
    origin_id   = local.s3_origin_id
    origin_path = var.origin_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity[0].cloudfront_access_identity_path
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.ssl_support_method
    minimum_protocol_version       = var.minimum_protocol_version
  }

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = local.s3_origin_id
    compress         = var.compress
    trusted_signers  = var.trusted_signers
    smooth_streaming = var.smooth_streaming
    forwarded_values {
      query_string = var.forward_query_string
      headers      = var.forward_header_values
      cookies {
        forward           = var.forward_cookies
        whitelisted_names = var.forward_cookies_whitelisted_names
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    default_ttl            = var.default_ttl
    min_ttl                = var.min_ttl
    max_ttl                = var.max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  custom_error_response {
    error_caching_min_ttl = var.error_caching_min_ttl
    error_code            = var.error_code
    response_code         = var.response_code
    response_page_path    = var.response_page_path
  }

  tags = module.labels.tags
}

# Module      : CLOUDFRONT CussDISTRIBUSTION
# Description : Creates an Amazon CloudFront web distribution
#tfsec:ignore:aws-cloudfront-use-secure-tls-policy
#tfsec:ignore:aws-cloudfront-enable-waf
resource "aws_cloudfront_distribution" "domain" {
  count = var.cdn_enabled == true && var.custom_domain == true ? 1 : 0

  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  price_class         = var.price_class
  aliases             = var.aliases
  default_root_object = var.default_root_object

  origin {
    domain_name = var.domain_name
    origin_id   = module.labels.id
    origin_path = var.origin_path

    custom_origin_config {
      http_port                = var.origin_http_port
      https_port               = var.origin_https_port
      origin_protocol_policy   = var.origin_protocol_policy
      origin_ssl_protocols     = var.origin_ssl_protocols
      origin_keepalive_timeout = var.origin_keepalive_timeout
      origin_read_timeout      = var.origin_read_timeout
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.ssl_support_method
    minimum_protocol_version       = var.minimum_protocol_version
  }

  default_cache_behavior {
    target_origin_id = module.labels.id
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    compress         = var.compress
    smooth_streaming = var.smooth_streaming
    trusted_signers  = var.trusted_signers
    forwarded_values {
      query_string = var.forward_query_string
      headers      = var.forward_header_values
      cookies {
        forward           = var.forward_cookies
        whitelisted_names = var.forward_cookies_whitelisted_names
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    default_ttl            = var.default_ttl
    min_ttl                = var.min_ttl
    max_ttl                = var.max_ttl
  }

  web_acl_id = var.web_acl_id

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  custom_error_response {
    error_code         = var.error_code
    response_page_path = var.response_page_path
    response_code      = var.response_code

  }

  tags = module.labels.tags
}

# Module      : CLOUDFRONT PUBLIC KEY
# Description : Creates a CloudFront public key
resource "aws_cloudfront_public_key" "default" {
  count = var.cdn_enabled == true && var.public_key_enable == true ? 1 : 0

  comment     = var.comment
  encoded_key = file(var.public_key)
  name        = format("%s-key", module.labels.id)
}