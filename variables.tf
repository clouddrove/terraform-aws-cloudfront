#Module      : LABEL
#Description : Terraform label module variables
variable "application" {
  type        = string
  description = "Application (e.g. `cp` or `clouddrove`)"
}

variable "environment" {
  type        = string
  description = "Environment (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = string
}

variable "label_order" {
  type        = list
  default     = []
  description = "label order, e.g. `name`,`application`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

# Module      : CDN Module
# Description : Terraform CDN module variables
variable "aliases" {
  type        = list(string)
  description = "List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront"
  default     = []
}

variable "bucket_name" {
  type        = string
  description = "A unique identifier for the origin"
  default     = ""
}

variable "origin_path" {
  description = "An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin. It must begin with a /. Do not add a / at the end of the path."
  default     = ""
}

variable "viewer_protocol_policy" {
  description = "allow-all, redirect-to-https"
  default     = ""
}

variable "allowed_methods" {
  type        = list(string)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  description = "List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront"
}

variable "cached_methods" {
  type        = list(string)
  default     = ["GET", "HEAD"]
  description = "List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD)"
}

variable "compress" {
  type        = string
  description = "Compress content for web requests that include Accept-Encoding: gzip in the request header"
  default     = ""
}

variable "default_ttl" {
  type        = string
  description = "Default amount of time (in seconds) that an object is in a CloudFront cache"
  default     = "60"
}

variable "max_ttl" {
  type        = string
  description = "Maximum amount of time (in seconds) that an object is in a CloudFront cache"
  default     = "31536000"
}

variable "min_ttl" {
  type        = string
  description = "Minimum amount of time that you want objects to stay in CloudFront caches"
  default     = "0"
}

variable "forward_query_string" {
  type        = string
  description = "Forward query strings to the origin that is associated with this cache behavior"
  default     = "false"
}

variable "forward_header_values" {
  type        = list(string)
  description = "A list of whitelisted header values to forward to the origin"
  default     = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
}

variable "smooth_streaming" {
  type        = string
  description = "(Optional) - Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior"
  default     = "false"
}

variable "forward_cookies" {
  type        = string
  description = "Time in seconds that browser can cache the response for S3 bucket"
  default     = "none"
}

variable "price_class" {
  type        = string
  description = "Price class for this distribution: `PriceClass_All`, `PriceClass_200`, `PriceClass_100`"
  default     = "PriceClass_100"
}

variable "geo_restriction_type" {
  type        = string
  description = "Method that use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist`"
  default     = "none"
}

variable "geo_restriction_locations" {
  type        = list(string)
  description = "List of country codes for which  CloudFront either to distribute content (whitelist) or not distribute your content (blacklist)"
  default     = []
}

variable "acm_certificate_arn" {
  type        = string
  description = "Existing ACM Certificate ARN"
  default     = ""
}

variable "minimum_protocol_version" {
  type        = string
  description = "Cloudfront TLS minimum protocol version"
  default     = "TLSv1"
}

variable "http_version" {
  type        = string
  description = "(Optional) - The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2"
  default     = "http2"
}

variable "is_ipv6_enabled" {
  type        = string
  default     = "true"
  description = "State of CloudFront IPv6"
}

variable "comment" {
  type        = string
  description = "Comment for the origin access identity"
  default     = "Managed by Clouddrove"
}

variable "enabled" {
  type        = string
  description = "Select Enabled if you want CloudFront to begin processing requests as soon as the distribution is created, or select Disabled if you do not want CloudFront to begin processing requests after the distribution is created"
  default     = "true"
}
variable "enabled_bucket" {
  type        = string
  description = "If cdn create with s3 bucket"
  default     = "false"

}
variable "custom_domain" {
  type        = string
  description = "If cdn create with custom Domain"
  default     = "false"
}

variable "origin_force_destroy" {
  type        = string
  description = "Delete all objects from the bucket  so that the bucket can be destroyed without error (e.g. `true` or `false`)"
  default     = "false"

}

variable "trusted_signers" {
  type        = list(string)
  description = "(Optional) - The AWS accounts, if any, that you want to allow to create signed URLs for private content."
  default     = []
}

variable "default_root_object" {
  description = "Object that CloudFront return when requests the root URL"
  default     = "index.html"
}

variable "ssl_support_method" {
  type        = string
  description = "Specifies how you want CloudFront to serve HTTPS requests. One of `vip` or `sni-only`"
  default     = "sni-only"
}

variable "forward_cookies_whitelisted_names" {
  type        = list
  description = "List of forwarded cookie names"
  default     = []
}

variable "error_code" {
  type        = string
  description = "List of forwarded cookie names"
  default     = "404"
}

variable "response_page_path" {
  type        = string
  description = "The path of the custom error page (for example, /custom_404.html)"
  default     = ""
}

variable "public_key_enable" {
  description = "Public key enable or disable"
  default     = "false"
}

variable "public_key" {
  description = "he encoded public key that you want to add to CloudFront to use with features like field-level encryption"
  default     = ""
}

variable "origin_http_port" {
  description = "(Required) - The HTTP port the custom origin listens on"
  default     = "80"
}

variable "origin_https_port" {
  description = "(Required) - The HTTPS port the custom origin listens on"
  default     = "443"
}

variable "origin_protocol_policy" {
  description = "(Required) - The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer"
  default     = "match-viewer"
}

variable "origin_ssl_protocols" {
  description = "(Required) - The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS"
  default     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
}

variable "origin_keepalive_timeout" {
  description = "(Optional) The Custom KeepAlive timeout, in seconds. By default, AWS enforces a limit of 60. But you can request an increase."
  default     = "60"
}

variable "origin_read_timeout" {
  description = "(Optional) The Custom Read timeout, in seconds. By default, AWS enforces a limit of 60. But you can request an increase."
  default     = "60"
}

variable "domain_name" {
  description = "(Required) - The DNS domain name of your custom origin (e.g. clouddrove.com)"
  default     = ""
}

variable "web_acl_id" {
  description = "(Optional) - Web ACL ID that can be attached to the Cloudfront distribution"
  default     = ""
}