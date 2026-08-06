provider "aws" {
  region = "us-east-1"
}

##-----------------------------------------------------------------------------
## CloudFront in front of a PRIVATE origin, through a VPC origin.
##
## This is the path that had no example, and consequently shipped broken: the
## module resolved an origin's vpc_origin_id through
## `aws_cloudfront_vpc_origin.this` while declaring the resource as
## `aws_cloudfront_vpc_origin.vpc_origin`, so any distribution with a
## vpc_origin_config failed at plan with "A managed resource
## aws_cloudfront_vpc_origin.this has not been declared".
##
## The point of a VPC origin is that the load balancer stays internal: an
## ordinary CloudFront origin must be publicly resolvable, which means an
## internet-facing ALB and a second path to the application that bypasses the
## edge entirely.
##-----------------------------------------------------------------------------
module "cloudfront" {
  source = "../../"

  name        = "cloudfront-vpc-origin"
  environment = "test"

  create_vpc_origin = true

  vpc_origin = {
    alb = {
      name                   = "internal-alb"
      arn                    = var.alb_arn
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"

      origin_ssl_protocols = {
        items    = ["TLSv1.2"]
        quantity = 1
      }
    }
  }

  ## The origin references the VPC origin BY NAME, which is the case the fix
  ## restores. Passing vpc_origin_id explicitly works too, but the by-name path
  ## is what the module documents.
  origin = {
    internal-alb = {
      domain_name = var.alb_dns_name

      vpc_origin_config = {
        vpc_origin               = "alb"
        origin_keepalive_timeout = 60
        origin_read_timeout      = 60
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "internal-alb"
    viewer_protocol_policy = "https-only"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
  }
}
