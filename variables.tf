#Module      : LABEL
#Description : Terraform label module variables
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-cloudfront-cdn"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

# Module      : CDN Module
# Description : Terraform CDN module variables
variable "aliases" {
  type        = list(string)
  default     = []
  description = "List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront."
}

variable "continuous_deployment_policy_id" {
  description = "Identifier of a continuous deployment policy. This argument should only be set on a production distribution."
  type        = string
  default     = null
}

variable "http_version" {
  description = "The maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3, and http3. The default is http2."
  type        = string
  default     = "http2"
}

variable "bucket_name" {
  type        = string
  default     = ""
  description = "A unique identifier for the origin."
  sensitive   = true
}

variable "origin" {
  description = "One or more origins for this distribution (multiples allowed)."
  type        = any
  default     = null
}

variable "origin_group" {
  description = "One or more origin_group for this distribution (multiples allowed)."
  type        = any
  default     = {}
}

variable "origin_path" {
  type        = string
  default     = ""
  description = "An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin. It must begin with a /. Do not add a / at the end of the path."
}

variable "create_origin_access_identity" {
  description = "Controls if CloudFront origin access identity should be created"
  type        = bool
  default     = false
}

variable "origin_access_identities" {
  description = "Map of CloudFront origin access identities (value as a comment)"
  type        = map(string)
  default     = {}
}

variable "create_origin_access_control" {
  description = "Controls if CloudFront origin access control should be created"
  type        = bool
  default     = false
}

variable "origin_access_control" {
  description = "Map of CloudFront origin access control"
  type = map(object({
    description      = string
    origin_type      = string
    signing_behavior = string
    signing_protocol = string
  }))

  default = {
    s3 = {
      description      = "",
      origin_type      = "s3",
      signing_behavior = "always",
      signing_protocol = "sigv4"
    }
  }
}

variable "create_vpc_origin" {
  description = "If enabled, the resource for VPC origin will be created."
  type        = bool
  default     = false
}

variable "vpc_origin" {
  description = "Map of CloudFront VPC origin"
  type = map(object({
    name                   = string
    arn                    = string
    http_port              = number
    https_port             = number
    origin_protocol_policy = string
    origin_ssl_protocols = object({
      items    = list(string)
      quantity = number
    })
  }))
  default = {}
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution (maximum one)."
  type        = any
  default     = {}
}

variable "geo_restriction" {
  description = "The restriction configuration for this distribution (geo_restrictions)"
  type        = any
  default     = {}
}

variable "custom_error_response" {
  description = "One or more custom error response elements"
  type        = any
  default     = {}
}

variable "ordered_cache_behavior" {
  description = "An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0."
  type        = any
  default     = []
}

variable "default_cache_behavior" {
  description = "The default cache behavior for this distribution"
  type        = any
  default     = null
}

variable "viewer_protocol_policy" {
  type        = string
  default     = ""
  description = "Allow-all, redirect-to-https."
}

variable "allowed_methods" {
  type        = list(string)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  description = "List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront."
}

variable "cached_methods" {
  type        = list(string)
  default     = ["GET", "HEAD"]
  description = "List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD)."
}

variable "compress" {
  type        = bool
  default     = false
  description = "Compress content for web requests that include Accept-Encoding: gzip in the request header."
}

variable "default_ttl" {
  type        = number
  default     = 60
  description = "Default amount of time (in seconds) that an object is in a CloudFront cache."
}

variable "max_ttl" {
  type        = number
  default     = 31536000
  description = "Maximum amount of time (in seconds) that an object is in a CloudFront cache."
}

variable "min_ttl" {
  type        = number
  default     = 0
  description = "Minimum amount of time that you want objects to stay in CloudFront caches."
}

variable "forward_query_string" {
  type        = bool
  default     = false
  description = "Forward query strings to the origin that is associated with this cache behavior."
}

variable "forward_header_values" {
  type        = list(string)
  default     = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
  description = "A list of whitelisted header values to forward to the origin."
}

variable "smooth_streaming" {
  type        = bool
  default     = false
  description = "Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior."
}

variable "forward_cookies" {
  type        = string
  default     = "none"
  description = "Time in seconds that browser can cache the response for S3 bucket."
}

variable "price_class" {
  type        = string
  default     = "PriceClass_100"
  description = "Price class for this distribution: `PriceClass_All`, `PriceClass_200`, `PriceClass_100`."
}

variable "geo_restriction_type" {
  type        = string
  default     = "none"
  description = "Method that use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist`."
}

variable "geo_restriction_locations" {
  type        = list(string)
  default     = []
  description = "List of country codes for which  CloudFront either to distribute content (whitelist) or not distribute your content (blacklist)."
  sensitive   = true
}

variable "acm_certificate_arn" {
  type        = string
  default     = ""
  description = "Existing ACM Certificate ARN."
  sensitive   = true
}

variable "is_ipv6_enabled" {
  type        = bool
  default     = true
  description = "State of CloudFront IPv6."
}

variable "comment" {
  type        = string
  default     = "Managed by Clouddrove"
  description = "Comment for the origin access identity."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Select Enabled if you want CloudFront to begin processing requests as soon as the distribution is created, or select Disabled if you do not want CloudFront to begin processing requests after the distribution is created."
}

variable "enabled_bucket" {
  type        = bool
  default     = false
  description = "If cdn create with s3 bucket."
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type        = any
  default = {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}

variable "custom_domain" {
  type        = bool
  default     = false
  description = "If cdn create with custom Domain."
}

variable "trusted_signers" {
  type        = list(string)
  default     = []
  description = "The AWS accounts, if any, that you want to allow to create signed URLs for private content."
}

variable "default_root_object" {
  type        = string
  default     = "index.html"
  description = "Object that CloudFront return when requests the root URL."
}

variable "forward_cookies_whitelisted_names" {
  type        = list(any)
  default     = []
  description = "List of forwarded cookie names."
  sensitive   = true
}

variable "error_code" {
  type        = string
  default     = "403"
  description = "List of forwarded cookie names."
}


variable "response_page_path" {
  type        = string
  default     = "/index.html"
  description = "The path of the custom error page (for example, /custom_404.html)."
}

variable "public_key_enable" {
  type        = bool
  default     = false
  description = "Public key enable or disable."
}

variable "public_key" {
  type        = string
  default     = ""
  description = "It encoded public key that you want to add to CloudFront to use with features like field-level encryption."
  sensitive   = true
}

variable "origin_http_port" {
  type        = number
  default     = 80
  description = "The HTTP port the custom origin listens on."
}

variable "origin_https_port" {
  type        = number
  default     = 443
  description = "The HTTPS port the custom origin listens on."
}

variable "origin_protocol_policy" {
  type        = string
  default     = "match-viewer"
  description = "The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer."
}

variable "origin_ssl_protocols" {
  type        = list(string)
  default     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
  description = "The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS."
}

variable "origin_keepalive_timeout" {
  type        = number
  default     = 60
  description = "The Custom KeepAlive timeout, in seconds. By default, AWS enforces a limit of 60. But you can request an increase."
}

variable "origin_read_timeout" {
  type        = number
  default     = 60
  description = "The Custom Read timeout, in seconds. By default, AWS enforces a limit of 60. But you can request an increase."
}

variable "domain_name" {
  type        = string
  default     = ""
  description = "The DNS domain name of your custom origin (e.g. clouddrove.com)."
  sensitive   = true
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards."
  type        = bool
  default     = false
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process."
  type        = bool
  default     = true
}

variable "staging" {
  description = "Whether the distribution is a staging distribution."
  type        = bool
  default     = false
}

variable "web_acl_id" {
  type        = string
  default     = ""
  description = "Web ACL ID that can be attached to the Cloudfront distribution."
  sensitive   = true
}

variable "cdn_enabled" {
  type        = bool
  default     = true
  description = "Select Enabled if you want to created CloudFront."
}


variable "response_code" {
  type        = string
  default     = "404"
  description = "page not found code"
}


variable "error_caching_min_ttl" {
  type        = string
  default     = "10"
  description = "the value of errro caching min ttl"
}