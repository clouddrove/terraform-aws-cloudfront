output "domain_name" {
  description = "CloudFront domain name serving the private origin."
  value       = module.cloudfront.domain_name
}
