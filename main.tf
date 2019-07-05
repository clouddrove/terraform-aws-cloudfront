## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

#Module      : label
#Description : Terraform module to create consistent naming for multiple names.
module "lables" {
  source = "git::https://github.com/clouddrove/terraform-lables.git"

  name        = var.name
  application = var.application
  environment = var.environment
  label_order = var.label_order
}

# Module      : CLOUDFRONT ORIGIN ACCESS IDENENTITY
# Description : Creates an Amazon CloudFront origin access identity
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.bucket_name}.s3.amazonaws.com"
}

locals {
  s3_origin_id = var.bucket_name
}
# Module      : CLOUDFRONT DISTRIBUSTION
# Description : Creates an Amazon CloudFront web distribution
resource "aws_cloudfront_distribution" "default" {
  count               = var.enabled == "true" ? 1 : 0
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  price_class         = var.price_class
  aliases             = var.aliases
  default_root_object = var.default_root_object


  origin {
    domain_name = "${var.bucket_name}.s3.amazonaws.com"
    origin_id   = local.s3_origin_id
    origin_path = var.origin_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
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
    error_code         = var.error_code
    response_page_path = var.response_page_path
  }
  tags = module.lables.tags
}
# Module      : CLOUDFRONT PUBLIC KEY
# Description : Creates a CloudFront public key
resource "aws_cloudfront_public_key" "default" {
  count       = var.public_key_enable == "true" ? 1 : 0
  comment     = var.comment
  encoded_key = file(var.public_key)
  name        = module.lables.id
}