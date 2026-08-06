variable "alb_arn" {
  type        = string
  description = "ARN of an existing internal Application Load Balancer to front. A VPC origin attaches to the load balancer itself, so it stays private."
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of that load balancer. Resolvable only inside the VPC, which is the point of using a VPC origin."
}
