variable "organization" {
  type        = "string"
  description = "Organization (e.g. `cp` or `anmolnagpal`)"
}

variable "environment" {
  type        = "string"
  description = "Environment (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = "string"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}
variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}
variable "aliases" {
  type        = "list"
  description = "List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront"
  default     = []
}
variable "origin_id" {
  description = "(Required) - A unique identifier for the origin"
  default     = ""
}
variable "bucket_domain_name" {
  description = "(Required) - domain of s3"
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
  type        = "list"
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  description = "List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront"
}
variable "cached_methods" {
  type        = "list"
  default     = ["GET", "HEAD"]
  description = "List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD)"
}
variable "compress" {
  default     = ""
  description = "Compress content for web requests that include Accept-Encoding: gzip in the request header"
}

variable "default_ttl" {
  default     = "60"
  description = "Default amount of time (in seconds) that an object is in a CloudFront cache"
}

variable "max_ttl" {
  default     = "31536000"
  description = "Maximum amount of time (in seconds) that an object is in a CloudFront cache"
}
variable "min_ttl" {
  default     = "0"
  description = "Minimum amount of time that you want objects to stay in CloudFront caches"
}
variable "forward_query_string" {
  default     = "false"
  description = "Forward query strings to the origin that is associated with this cache behavior"
}
variable "forward_header_values" {
  type        = "list"
  description = "A list of whitelisted header values to forward to the origin"
  default     = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
}

variable "smooth_streaming" {
  default     = "false"
  description = "(Optional) - Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior"
}
variable "forward_cookies" {
  default     = "none"
  description = "Time in seconds that browser can cache the response for S3 bucket"
}

variable "price_class" {
  default     = "PriceClass_100"
  description = "Price class for this distribution: `PriceClass_All`, `PriceClass_200`, `PriceClass_100`"
}
variable "geo_restriction_type" {
  default     = "none"
  description = "Method that use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist`"
}

variable "geo_restriction_locations" {
  type = "list"
  default     = []
  description = "List of country codes for which  CloudFront either to distribute content (whitelist) or not distribute your content (blacklist)"
}
variable "acm_certificate_arn" {
  description = "Existing ACM Certificate ARN"
  default     = ""
}
variable "minimum_protocol_version" {
  description = "Cloudfront TLS minimum protocol version"
  default     = "TLSv1"
}
variable "http_version" {
  description = "(Optional) - The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2"
  default     = "http2"
}

variable "is_ipv6_enabled" {
  default     = "true"
  description = "State of CloudFront IPv6"
}
variable "comment" {
  default     = "Managed by Clouddrove"
  description = "Comment for the origin access identity"
}


variable "enabled" {
  default     = "true"
  description = "Select Enabled if you want CloudFront to begin processing requests as soon as the distribution is created, or select Disabled if you do not want CloudFront to begin processing requests after the distribution is created."
}


variable "origin_bucket" {
  default     = ""
  description = "Name of S3 bucket"
}


variable "origin_force_destroy" {
  default     = "false"
  description = "Delete all objects from the bucket  so that the bucket can be destroyed without error (e.g. `true` or `false`)"
}

variable "bucket_domain_format" {
  default     = "s3.amazonaws.com"
  description = "Format of bucket domain name"
}



variable "cors_allowed_headers" {
  type        = "list"
  default     = ["*"]
  description = "List of allowed headers for S3 bucket"
}


variable "parent_zone_id" {
  default     = ""
  description = "ID of the hosted zone to contain this record  (or specify `parent_zone_name`)"
}

variable "parent_zone_name" {
  default     = ""
  description = "Name of the hosted zone to contain this record (or specify `parent_zone_id`)"
}



variable "custom_error_response" {
  # http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/custom-error-pages.html#custom-error-pages-procedure
  # https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#custom-error-response-arguments
  description = "List of one or more custom error response element maps"

  type    = "list"
  default = []
}
variable "trusted_signers" {
  type =  "list"
  description = "(Optional) - The AWS accounts, if any, that you want to allow to create signed URLs for private content."
  default = []
}
