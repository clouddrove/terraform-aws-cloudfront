# Module      : CLOUDFRONT DISTRIBUSTION
# Description : Creates an Amazon CloudFront web distribution
output "id" {
  value = try(aws_cloudfront_distribution.this[0].id, "")
  description = "The identifier for the distribution."
}

output "arn" {
  value = try(aws_cloudfront_distribution.this[0].arn, "")
  description = "The ARN (Amazon Resource Name) for the distribution."
}

output "status" {
  value = try(aws_cloudfront_distribution.this[0].status, "")
  description = "The current status of the distribution."
}

output "domain_name" {
  value = try(aws_cloudfront_distribution.this[0].domain_name, "")
  description = "The domain name corresponding to the distribution."
}

output "etag" {
  value = try(aws_cloudfront_distribution.this[0].etag, "")
  description = "The current version of the distribution's information."
}
output "hosted_zone_id" {
  value = try(aws_cloudfront_distribution.this[0].hosted_zone_id, "")
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
}

# Module      : CLOUDFRONT PUBLIC KEY
# Description : Creates a CloudFront public key
output "pubkey_id" {
  value = concat(
    aws_cloudfront_public_key.default[*].id
  )
  description = "The identifier for the public key."
}

output "pubkey_etag" {
  value = concat(
    aws_cloudfront_public_key.default[*].etag
  )
  description = "The current version of the public key."
}

# Module      : CLOUDFRONT ORIGIN ACCESS IDENENTITY
# Description : Creates an Amazon CloudFront origin access identity

output "access_identity_ids" {
  description = "The IDS of the origin access identities created"
  value       = [for v in aws_cloudfront_origin_access_identity.origin_access_identity : v.id if local.create_origin_access_identity]
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}