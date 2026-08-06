# CloudFront with a VPC origin

Fronts a **private** Application Load Balancer. The load balancer never becomes
internet-facing: CloudFront reaches it through a VPC origin, so the only public
surface is the distribution.

Requires an existing internal ALB; pass its ARN and DNS name.

```bash
terraform init
terraform plan -var alb_arn=<arn> -var alb_dns_name=<dns>
```
