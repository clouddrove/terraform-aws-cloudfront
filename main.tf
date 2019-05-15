module "label" {
  source       = "git::https://github.com/clouddrove/terraform-lables.git"
  organization = "${var.organization}"
  name         = "${var.name}"
  environment  = "${var.environment}"
  delimiter    = "${var.delimiter}"
  attributes   = "${var.attributes}"
  tags         = "${var.tags}"
}
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.origin_id}.s3.amazonaws.com"
}
locals {
  s3_origin_id =       "${var.origin_id}"
}
resource "aws_cloudfront_distribution" "default" {
  enabled             = "${var.enabled}"
  is_ipv6_enabled     = "${var.is_ipv6_enabled}"
  comment             = "${var.comment}"
  price_class         = "${var.price_class}"
  aliases = ["${var.aliases}"]
  origin {
    domain_name = "${var.origin_id}.s3.amazonaws.com"
    origin_id   = "${local.s3_origin_id}"
    origin_path = "${var.origin_path}"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = "${var.acm_certificate_arn}"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "${var.minimum_protocol_version}"
    cloudfront_default_certificate = "${var.acm_certificate_arn == "" ? true : false}"
  }
  default_cache_behavior {
    allowed_methods  = "${var.allowed_methods}"
    cached_methods   = "${var.cached_methods}"
    target_origin_id = "${local.s3_origin_id}"
    compress         = "${var.compress}"
    trusted_signers  =  ["${var.trusted_signers}"]
    smooth_streaming = "${var.smooth_streaming}"
    forwarded_values {
      query_string = "${var.forward_query_string}"
      headers      = ["${var.forward_header_values}"]
      cookies {
        forward = "${var.forward_cookies}"
      }
    }
    viewer_protocol_policy = "${var.viewer_protocol_policy}"
    default_ttl            = "${var.default_ttl}"
    min_ttl                = "${var.min_ttl}"
    max_ttl                = "${var.max_ttl}"
  }
  restrictions {
    geo_restriction {
      restriction_type = "${var.geo_restriction_type}"
      locations        = "${var.geo_restriction_locations}"
    }
  }

  custom_error_response = ["${var.custom_error_response}"]
  tags = "${module.label.tags}"
}


