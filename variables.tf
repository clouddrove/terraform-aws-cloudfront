#Module      : LABEL
#Description : Terraform label module variables
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "application" {
  type        = string
  default     = ""
  description = "Application (e.g. `cd` or `clouddrove`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list
  default     = []
  description = "label order, e.g. `name`,`application`."
}

variable "attributes" {
  type        = list
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `organization`, `environment`, `name` and `attributes`"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

# Module      : CDN Module
# Description : Terraform CDN module variables
variable "aliases" {
  type        = list(string)
  default     = []
  description = "List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront."
}

variable "bucket_name" {
  type        = string
  default     = ""
  description = "A unique identifier for the origin."
}

variable "origin_path" {
  type        = string
  default     = ""
  description = "An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin. It must begin with a /. Do not add a / at the end of the path."
}

variable "viewer_protocol_policy" {
  type        = string
  default     = ""
  description = "allow-all, redirect-to-https."
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
}

variable "acm_certificate_arn" {
  type        = string
  default     = ""
  description = "Existing ACM Certificate ARN."
}

variable "minimum_protocol_version" {
  type        = string
  default     = "TLSv1"
  description = "Cloudfront TLS minimum protocol version."
}

variable "http_version" {
  type        = string
  default     = "http2"
  description = "The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2."
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

variable "custom_domain" {
  type        = bool
  default     = false
  description = "If cdn create with custom Domain."
}

variable "origin_force_destroy" {
  type        = bool
  default     = false
  description = "Delete all objects from the bucket  so that the bucket can be destroyed without error (e.g. `true` or `false`)."
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

variable "ssl_support_method" {
  type        = string
  default     = "sni-only"
  description = "Specifies how you want CloudFront to serve HTTPS requests. One of `vip` or `sni-only`."
}

variable "forward_cookies_whitelisted_names" {
  type        = list
  default     = []
  description = "List of forwarded cookie names."
}

variable "error_code" {
  type        = string
  default     = "404"
  description = "List of forwarded cookie names."
}

variable "response_page_path" {
  type        = string
  default     = null
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
  description = "he encoded public key that you want to add to CloudFront to use with features like field-level encryption."
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
}

variable "web_acl_id" {
  type        = string
  default     = ""
  description = "Web ACL ID that can be attached to the Cloudfront distribution."
}