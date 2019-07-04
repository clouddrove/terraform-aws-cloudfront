# Module      : CLOUDFRONT DISTRIBUSTION
# Description : Creates an Amazon CloudFront web distribution
output "id" {
  value       = aws_cloudfront_distribution.default.id
  description = "ID of AWS CloudFront distribution"
}

output "arn" {
  value       = aws_cloudfront_distribution.default.arn
  description = "ARN of AWS CloudFront distribution"
}

output "status" {
  value       = aws_cloudfront_distribution.default.status
  description = "Current status of the distribution"
}

output "domain_name" {
  value       = aws_cloudfront_distribution.default.domain_name
  description = "Domain name corresponding to the distribution"
}

output "etag" {
  value       = aws_cloudfront_distribution.default.etag
  description = "Current version of the distribution's information"
}

output "hosted_zone_id" {
  value       = aws_cloudfront_distribution.default.hosted_zone_id
  description = "CloudFront Route 53 zone ID"
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
  value       = aws_cloudfront_origin_access_identity.origin_access_identity.id
  description = "ID of AWS CloudFront distribution"
}

output "access_identity_etag" {
  value       = aws_cloudfront_origin_access_identity.origin_access_identity.etag
  description = "ID of AWS CloudFront distribution"
}
