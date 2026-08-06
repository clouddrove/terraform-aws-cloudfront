output "domain_name" {
  description = "Distribution domain. Requests without a trusted client certificate are refused here."
  value       = module.cloudfront.domain_name
}
