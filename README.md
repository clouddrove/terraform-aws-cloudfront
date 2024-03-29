<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AWS Cloudfront CDN
</h1>

<p align="center" style="font-size: 1.2rem;"> 
    Terraform module provisions CloudFront CDN resource on AWS.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v1.1.7-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>
<a href="https://github.com/clouddrove/terraform-aws-cloudfront/actions/workflows/tfsec.yml">
  <img src="https://github.com/clouddrove/terraform-aws-cloudfront/actions/workflows/tfsec.yml/badge.svg" alt="tfsec">
</a>

</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-cloudfront-cdn'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+Cloudfront+CDN&url=https://github.com/clouddrove/terraform-aws-cloudfront-cdn'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+Cloudfront+CDN&url=https://github.com/clouddrove/terraform-aws-cloudfront-cdn'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards strategies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure. 

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies: 

- [Terraform 1.x.x](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-aws-cloudfront-cdn/releases).


Here are some examples of how you can use this module in your inventory structure:
### CDN With Basic Bucket
```hcl
      module "cdn" {
        source                 = "clouddrove/cloudfront-cdn/aws"
        version                = "1.0.1"
        name                   = "basic-cdn"
        environment            = "test"
        label_order            = ["name", "environment"]
        enabled_bucket         = true
        compress               = false
        aliases                = ["clouddrove.com"]
        bucket_name            = "test-bucket"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods        = ["GET", "HEAD"]
        acm_certificate_arn    = "arn:aws:acm:eu-west-1:xxxxxxxxxxxx:certificate/xxxxxx-xxxx-xxxxx-xxxx"
      }
```

### CDN With Secure Bucket
```hcl
      module "cdn" {
        source                 = "clouddrove/cloudfront-cdn/aws"
        version                = "1.0.1"
        name                   = "secure-cdn"
        environment            = "test"
        label_order            = ["name", "environment"]
        aliases                = ["clouddrove.com"]
        bucket_name            = "test-bucket"
        viewer_protocol_policy = "redirect-to-https"
        compress               = false
        allowed_methods        = ["GET", "HEAD"]
        acm_certificate_arn    = "arn:aws:acm:eu-west-1:xxxxxxxxxxxx:certificate/xxxxxx-xxxx-xxxxx-xxxx"
        trusted_signers        = ["self"]
        public_key_enable      = true
        public_key             = "./../cdn.pem"
      }
```
### CDN With Domain
```hcl
    module "cdn" {
      source                 = "clouddrove/cloudfront-cdn/aws"
      version                = "1.0.1"
      name                   = "domain-cdn"
      environment            = "test"
      label_order            = ["name", "environment"]
      custom_domain          = true
      compress               = false
      aliases                = ["clouddrove.com"]
      domain_name            = "clouddrove.com"
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ["GET", "HEAD"]
      acm_certificate_arn    = "arn:aws:acm:eu-west-1:xxxxxxxxxxxx:certificate/xxxxxx-xxxx-xxxxx-xxxx"
     }
```






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acm\_certificate\_arn | Existing ACM Certificate ARN. | `string` | `""` | no |
| aliases | List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront. | `list(string)` | `[]` | no |
| allowed\_methods | List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront. | `list(string)` | <pre>[<br>  "DELETE",<br>  "GET",<br>  "HEAD",<br>  "OPTIONS",<br>  "PATCH",<br>  "POST",<br>  "PUT"<br>]</pre> | no |
| attributes | Additional attributes (e.g. `1`). | `list(any)` | `[]` | no |
| bucket\_name | A unique identifier for the origin. | `string` | `""` | no |
| cached\_methods | List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD). | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| cdn\_enabled | Select Enabled if you want to created CloudFront. | `bool` | `true` | no |
| comment | Comment for the origin access identity. | `string` | `"Managed by Clouddrove"` | no |
| compress | Compress content for web requests that include Accept-Encoding: gzip in the request header. | `bool` | `false` | no |
| custom\_domain | If cdn create with custom Domain. | `bool` | `false` | no |
| default\_root\_object | Object that CloudFront return when requests the root URL. | `string` | `"index.html"` | no |
| default\_ttl | Default amount of time (in seconds) that an object is in a CloudFront cache. | `number` | `60` | no |
| delimiter | Delimiter to be used between `organization`, `environment`, `name` and `attributes`. | `string` | `"-"` | no |
| domain\_name | The DNS domain name of your custom origin (e.g. clouddrove.com). | `string` | `""` | no |
| enabled | Select Enabled if you want CloudFront to begin processing requests as soon as the distribution is created, or select Disabled if you do not want CloudFront to begin processing requests after the distribution is created. | `bool` | `true` | no |
| enabled\_bucket | If cdn create with s3 bucket. | `bool` | `false` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| error\_caching\_min\_ttl | the value of errro caching min ttl | `string` | `"10"` | no |
| error\_code | List of forwarded cookie names. | `string` | `"403"` | no |
| forward\_cookies | Time in seconds that browser can cache the response for S3 bucket. | `string` | `"none"` | no |
| forward\_cookies\_whitelisted\_names | List of forwarded cookie names. | `list(any)` | `[]` | no |
| forward\_header\_values | A list of whitelisted header values to forward to the origin. | `list(string)` | <pre>[<br>  "Access-Control-Request-Headers",<br>  "Access-Control-Request-Method",<br>  "Origin"<br>]</pre> | no |
| forward\_query\_string | Forward query strings to the origin that is associated with this cache behavior. | `bool` | `false` | no |
| geo\_restriction\_locations | List of country codes for which  CloudFront either to distribute content (whitelist) or not distribute your content (blacklist). | `list(string)` | `[]` | no |
| geo\_restriction\_type | Method that use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist`. | `string` | `"none"` | no |
| http\_version | The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2. | `string` | `"http2"` | no |
| is\_ipv6\_enabled | State of CloudFront IPv6. | `bool` | `true` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| max\_ttl | Maximum amount of time (in seconds) that an object is in a CloudFront cache. | `number` | `31536000` | no |
| min\_ttl | Minimum amount of time that you want objects to stay in CloudFront caches. | `number` | `0` | no |
| minimum\_protocol\_version | Cloudfront TLS minimum protocol version. | `string` | `"TLSv1"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| origin\_force\_destroy | Delete all objects from the bucket  so that the bucket can be destroyed without error (e.g. `true` or `false`). | `bool` | `false` | no |
| origin\_http\_port | The HTTP port the custom origin listens on. | `number` | `80` | no |
| origin\_https\_port | The HTTPS port the custom origin listens on. | `number` | `443` | no |
| origin\_keepalive\_timeout | The Custom KeepAlive timeout, in seconds. By default, AWS enforces a limit of 60. But you can request an increase. | `number` | `60` | no |
| origin\_path | An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin. It must begin with a /. Do not add a / at the end of the path. | `string` | `""` | no |
| origin\_protocol\_policy | The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer. | `string` | `"match-viewer"` | no |
| origin\_read\_timeout | The Custom Read timeout, in seconds. By default, AWS enforces a limit of 60. But you can request an increase. | `number` | `60` | no |
| origin\_ssl\_protocols | The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. | `list(string)` | <pre>[<br>  "TLSv1",<br>  "TLSv1.1",<br>  "TLSv1.2"<br>]</pre> | no |
| price\_class | Price class for this distribution: `PriceClass_All`, `PriceClass_200`, `PriceClass_100`. | `string` | `"PriceClass_100"` | no |
| public\_key | It encoded public key that you want to add to CloudFront to use with features like field-level encryption. | `string` | `""` | no |
| public\_key\_enable | Public key enable or disable. | `bool` | `false` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-cloudfront-cdn"` | no |
| response\_code | page not found code | `string` | `"404"` | no |
| response\_page\_path | The path of the custom error page (for example, /custom\_404.html). | `string` | `"/index.html"` | no |
| smooth\_streaming | Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior. | `bool` | `false` | no |
| ssl\_support\_method | Specifies how you want CloudFront to serve HTTPS requests. One of `vip` or `sni-only`. | `string` | `"sni-only"` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(any)` | `{}` | no |
| trusted\_signers | The AWS accounts, if any, that you want to allow to create signed URLs for private content. | `list(string)` | `[]` | no |
| viewer\_protocol\_policy | Allow-all, redirect-to-https. | `string` | `""` | no |
| web\_acl\_id | Web ACL ID that can be attached to the Cloudfront distribution. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_identity\_etag | The current version of the origin access identity's information. |
| access\_identity\_id | The identifier for the distribution. |
| arn | The ARN (Amazon Resource Name) for the distribution. |
| domain\_name | The domain name corresponding to the distribution. |
| etag | The current version of the distribution's information. |
| hosted\_zone\_id | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| id | The identifier for the distribution. |
| pubkey\_etag | The current version of the public key. |
| pubkey\_id | The identifier for the public key. |
| status | The current status of the distribution. |
| tags | A mapping of tags to assign to the resource. |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system. 

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback 
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-cloudfront-cdn/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-aws-cloudfront-cdn)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
