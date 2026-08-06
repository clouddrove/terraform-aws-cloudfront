# CloudFront with viewer mTLS

Only clients presenting a certificate signed by a CA in the trust store reach
the origin. CloudFront verifies at the edge and forwards the certificate details
to the origin as headers.

The trust store reads its CA bundle from S3 **by object version**, so rotating
the CA is a deliberate change rather than an overwrite that silently alters who
is trusted.

```bash
terraform init
terraform plan -var truststore_bucket=<bucket> -var origin_domain_name=<origin>
```
