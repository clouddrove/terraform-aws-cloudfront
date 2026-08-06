variable "truststore_bucket" {
  type        = string
  description = "Bucket holding the CA bundle that defines which clients are trusted."
}

variable "truststore_key" {
  type        = string
  description = "Key of the CA bundle PEM."
  default     = "truststore.pem"
}

variable "truststore_region" {
  type        = string
  description = "Region of the truststore bucket."
  default     = "us-east-1"
}

variable "truststore_version" {
  type        = string
  description = "S3 object version of the CA bundle. Pinning it makes a CA rotation a deliberate, reviewable change."
  default     = null
}

variable "origin_domain_name" {
  type        = string
  description = "Origin CloudFront forwards verified requests to."
}
