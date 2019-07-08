//# Module      : CLOUDFRONT DISTRIBUSTION
//# Description : Creates an Amazon CloudFront web distribution
//
output "id" {
  description = "The identifier for the distribution. For example"
  value = concat(
    aws_cloudfront_distribution.bucket.*.id,
    aws_cloudfront_distribution.domain.*.id
  )
}

output "arn" {
  description = "The ARN (Amazon Resource Name) for the distribution. For example"
  value = concat(
    aws_cloudfront_distribution.bucket.*.arn,
    aws_cloudfront_distribution.domain.*.arn
  )
}

output "status" {
  description = "The current status of the distribution"
  value = concat(
    aws_cloudfront_distribution.bucket.*.status,
    aws_cloudfront_distribution.domain.*.status
  )
}

output "domain_name" {
  description = " The domain name corresponding to the distribution. For example"
  value = concat(
    aws_cloudfront_distribution.bucket.*.domain_name,
    aws_cloudfront_distribution.domain.*.domain_name
  )
}
output "etag" {
  description = "The current version of the distribution's information. For example"
  value = concat(
    aws_cloudfront_distribution.bucket.*.etag,
    aws_cloudfront_distribution.domain.*.etag
  )
}
output "hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to"
  value = concat(
    aws_cloudfront_distribution.bucket.*.hosted_zone_id,
    aws_cloudfront_distribution.domain.*.hosted_zone_id
  )
}

# Module      : CLOUDFRONT PUBLIC KEY
# Description : Creates a CloudFront public key
output "pubkey_id" {
  value       = aws_cloudfront_public_key.default.*.id
  description = "ID of AWS CloudFront distribution"
}

output "pubkey_etag" {
  value       = aws_cloudfront_public_key.default.*.etag
  description = "Current version of the distribution's information"
}

# Module      : CLOUDFRONT ORIGIN ACCESS IDENENTITY
# Description : Creates an Amazon CloudFront origin access identity
output "access_identity_id" {
  value       = aws_cloudfront_origin_access_identity.origin_access_identity.*.id
  description = "ID of AWS CloudFront distribution"
}

output "access_identity_etag" {
  value       = aws_cloudfront_origin_access_identity.origin_access_identity.*.etag
  description = "ID of AWS CloudFront distribution"
}
