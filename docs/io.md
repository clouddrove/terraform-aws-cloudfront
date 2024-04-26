## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acm\_certificate\_arn | Existing ACM Certificate ARN. | `string` | `""` | no |
| aliases | List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront. | `list(string)` | `[]` | no |
| allowed\_methods | List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront. | `list(string)` | <pre>[<br>  "DELETE",<br>  "GET",<br>  "HEAD",<br>  "OPTIONS",<br>  "PATCH",<br>  "POST",<br>  "PUT"<br>]</pre> | no |
| bucket\_name | A unique identifier for the origin. | `string` | `""` | no |
| cached\_methods | List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD). | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| cdn\_enabled | Select Enabled if you want to created CloudFront. | `bool` | `true` | no |
| comment | Comment for the origin access identity. | `string` | `"Managed by Clouddrove"` | no |
| compress | Compress content for web requests that include Accept-Encoding: gzip in the request header. | `bool` | `false` | no |
| custom\_domain | If cdn create with custom Domain. | `bool` | `false` | no |
| default\_root\_object | Object that CloudFront return when requests the root URL. | `string` | `"index.html"` | no |
| default\_ttl | Default amount of time (in seconds) that an object is in a CloudFront cache. | `number` | `60` | no |
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
| is\_ipv6\_enabled | State of CloudFront IPv6. | `bool` | `true` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| max\_ttl | Maximum amount of time (in seconds) that an object is in a CloudFront cache. | `number` | `31536000` | no |
| min\_ttl | Minimum amount of time that you want objects to stay in CloudFront caches. | `number` | `0` | no |
| minimum\_protocol\_version | Cloudfront TLS minimum protocol version. | `string` | `"TLSv1"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
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

