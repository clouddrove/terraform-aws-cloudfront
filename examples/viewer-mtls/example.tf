provider "aws" {
  region = "us-east-1"
}

##-----------------------------------------------------------------------------
## Viewer mTLS: only clients presenting a certificate signed by the trust store
## CA reach the origin.
##
## CloudFront does the verification at the edge and forwards the certificate
## details to the origin as headers, so the application never implements
## certificate validation itself.
##-----------------------------------------------------------------------------
resource "aws_cloudfront_trust_store" "this" {
  name = "example-fleet"

  ca_certificates_bundle_source {
    ca_certificates_bundle_s3_location {
      bucket = var.truststore_bucket
      key    = var.truststore_key
      region = var.truststore_region

      ## Pin the object VERSION. Without it, overwriting the bundle silently
      ## changes which certificates are trusted, with no plan and no rollback.
      version = var.truststore_version
    }
  }
}

module "cloudfront" {
  source = "../../"

  name        = "cloudfront-viewer-mtls"
  environment = "test"

  origin = {
    example = {
      domain_name = var.origin_domain_name

      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "example"
    viewer_protocol_policy = "https-only"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
  }

  viewer_mtls_config = {
    trust_store_id = aws_cloudfront_trust_store.this.id

    ## "required" refuses a client presenting no certificate. "optional" admits
    ## it, which makes the control advisory rather than enforcing.
    mode = "required"
  }
}
