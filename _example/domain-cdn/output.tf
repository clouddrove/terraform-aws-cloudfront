output "id" {
  value       = module.cdn.*.arn
  description = "ID of AWS CloudFront distribution"
}

output "tags" {
  value       = module.acm.tags
  description = "A mapping of tags to assign to the CDN."
}