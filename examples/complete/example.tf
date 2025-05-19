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

  name                 = "${local.name}-certificate"
  environment          = local.environment
  domain_name               = "clouddrove.ca"
  subject_alternative_names = ["clouddrove.ca", "*.clouddrove.ca"]
  enable = true
  validation_method    = "DNS"
  validate_certificate = true
}

##---------------------------------------------------------------------------------------------------------------------------
## A VPC is a virtual network that closely resembles a traditional network that you'd operate in your own data center.
##--------------------------------------------------------------------------------------------------------------------------
module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.0"

  name        = "${local.name}-vpc"
  environment = local.environment
  cidr_block  = "172.16.0.0/16"
}

##-----------------------------------------------------
## A subnet is a range of IP addresses in your VPC.
##-----------------------------------------------------
module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.1"

  name               = "${local.name}-subnets"
  environment        = local.environment
  availability_zones = ["us-east-1a", "us-east-1b"]
  type               = "public"
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  igw_id             = module.vpc.igw_id
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}

##-----------------------------------------------------
## When your trusted identities assume IAM roles, they are granted only the permissions scoped by those IAM roles.
##-----------------------------------------------------
module "iam-role" {
  source             = "clouddrove/iam-role/aws"
  version            = "1.3.2"
  name               = local.name
  environment        = local.environment
  assume_role_policy = data.aws_iam_policy_document.default.json
  policy_enabled     = true
  policy             = data.aws_iam_policy_document.iam-policy.json
}

data "aws_iam_policy_document" "default" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "iam-policy" {
  statement {
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
    "ssmmessages:OpenDataChannel"]
    effect    = "Allow"
    resources = ["*"]
  }
}

##-----------------------------------------------------
## Amazon EC2 provides cloud hosted virtual machines, called "instances", to run applications.
##-----------------------------------------------------
module "ec2" {
  source  = "clouddrove/ec2/aws"
  version = "2.0.3"

  name                        = "${local.name}-ec2"
  environment                 = local.environment
  vpc_id                      = module.vpc.vpc_id
  ssh_allowed_ip              = ["0.0.0.0/0"]
  ssh_allowed_ports           = [22]
  instance_count              = 2
  ami                         = "ami-084568db4383264d4"
  instance_type               = "t2.nano"
  monitoring                  = true
  tenancy                     = "default"
  subnet_ids                  = tolist(module.public_subnets.public_subnet_id)
  iam_instance_profile        = module.iam-role.name
  assign_eip_address          = true
  associate_public_ip_address = true
  instance_profile_enabled    = true
  ebs_optimized               = false
  ebs_volume_enabled          = true
  ebs_volume_type             = "gp2"
  ebs_volume_size             = 30
}

##-----------------------------------------------------------------------------
## alb module call.
##-----------------------------------------------------------------------------
module "alb" {
  source  = "clouddrove/alb/aws"
  version = "2.0.0"

  name                       = "${local.name}-alb"
  enable                     = true
  internal                   = true
  load_balancer_type         = "application"
  instance_count             = module.ec2.instance_count
  subnets                    = module.public_subnets.public_subnet_id
  target_id                  = module.ec2.instance_id
  vpc_id                     = module.vpc.vpc_id
  allowed_ip                 = [module.vpc.vpc_cidr_block]
  allowed_ports              = [3306]
  listener_certificate_arn   = module.acm.arn
  enable_deletion_protection = false
  with_target_group          = true
  https_enabled              = true
  http_enabled               = true
  https_port                 = 443
  listener_type              = "forward"
  target_group_port          = 80

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 81
      protocol           = "TCP"
      target_group_index = 0
    },
  ]
  https_listeners = [
    {
      port               = 443
      protocol           = "TLS"
      target_group_index = 0
      certificate_arn    = module.acm.arn
    },
    {
      port               = 84
      protocol           = "TLS"
      target_group_index = 0
      certificate_arn    = module.acm.arn
    },
  ]

  target_groups = [
    {
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  extra_ssl_certs = [
    {
      https_listener_index = 0
      certificate_arn      = module.acm.arn
    }
  ]
}

module "cdn" {
  source = "./../../"

  name                   = "${local.name}-secure"
  environment            = local.environment
  cdn_enabled            = true
  compress               = false
  aliases                = ["clouddrove.ca"]
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

  origin = {
    s3_oac = { # with origin access control settings (recommended)
      domain_name           = module.s3_bucket.bucket_regional_domain_name
      origin_access_control = "s3_oac" # key in `origin_access_control`
      #      origin_access_control_id = "E345SXM82MIOSU" # external OAС resource
    },
    elb_origin = {
      domain_name = module.alb.dns_name
      origin_id   = "elb_origin"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "elb_origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    use_forwarded_values = false

    cache_policy_id            = "b2884449-e4de-46a7-ac36-70bc7f1ddd6d"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static-no-policies/*"
      target_origin_id       = "s3_oac"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]

      # Using Cache/ResponseHeaders/OriginRequest policies is not allowed together with `compress` and `query_string` settings
      compress     = true
      query_string = true
    },    
    {
      path_pattern           = "/api/*"
      target_origin_id       = "elb_origin"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]

      use_forwarded_values = false

      cache_policy_name            = "Managed-CachingOptimized"
      origin_request_policy_name   = "Managed-AllViewer"
      response_headers_policy_name = "Managed-SimpleCORS"
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
