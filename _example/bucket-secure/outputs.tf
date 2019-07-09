output "id" {
  value       = module.cdn.*.arn
  description = "ID of AWS CloudFront distribution"
}
