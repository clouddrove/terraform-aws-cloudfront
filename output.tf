# Module      : CLOUDFRONT DISTRIBUSTION
# Description : Creates an Amazon CloudFront web distribution
output "id" {
  value = concat(
    aws_cloudfront_distribution.bucket.*.id,
    aws_cloudfront_distribution.domain.*.id
  )[0]
  description = "The identifier for the distribution."
}

output "arn" {
  value = concat(
    aws_cloudfront_distribution.bucket.*.arn,
    aws_cloudfront_distribution.domain.*.arn
  )[0]
  description = "The ARN (Amazon Resource Name) for the distribution."
}

output "status" {
  value = concat(
    aws_cloudfront_distribution.bucket.*.status,
    aws_cloudfront_distribution.domain.*.status
  )[0]
  description = "The current status of the distribution."
}

output "domain_name" {
  value = concat(
    aws_cloudfront_distribution.bucket.*.domain_name,
    aws_cloudfront_distribution.domain.*.domain_name
  )[0]
  description = " The domain name corresponding to the distribution."
}

output "etag" {
  value = concat(
    aws_cloudfront_distribution.bucket.*.etag,
    aws_cloudfront_distribution.domain.*.etag
  )[0]
  description = "The current version of the distribution's information."
}
output "hosted_zone_id" {
  value = concat(
    aws_cloudfront_distribution.bucket.*.hosted_zone_id,
    aws_cloudfront_distribution.domain.*.hosted_zone_id
  )[0]
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
}

# Module      : CLOUDFRONT PUBLIC KEY
# Description : Creates a CloudFront public key
output "pubkey_id" {
  value = concat(
    aws_cloudfront_public_key.default.*.id
  )
  description = "The identifier for the public key."
}

output "pubkey_etag" {
  value = concat(
    aws_cloudfront_public_key.default.*.etag
  )
  description = "The current version of the public key."
}

# Module      : CLOUDFRONT ORIGIN ACCESS IDENENTITY
# Description : Creates an Amazon CloudFront origin access identity
output "access_identity_id" {
  value = concat(
    aws_cloudfront_origin_access_identity.origin_access_identity.*.id
  )
  description = "The identifier for the distribution."
}

output "access_identity_etag" {
  value = concat(aws_cloudfront_origin_access_identity.origin_access_identity.*.etag
  )
  description = "The current version of the origin access identity's information."
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}