# terraform-aws-cloudfront basic example

This is a basic example of the `terraform-aws-cloudfront` module.

## Usage

```hcl
module "cloudfront" {
  source      = "clouddrove/cloudfront/aws"
  name        = "cloudfront"
  environment = "test"
}
```
