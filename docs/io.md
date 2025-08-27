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
| continuous\_deployment\_policy\_id | Identifier of a continuous deployment policy. This argument should only be set on a production distribution. | `string` | `null` | no |
| create\_origin\_access\_control | Controls if CloudFront origin access control should be created | `bool` | `false` | no |
| create\_origin\_access\_identity | Controls if CloudFront origin access identity should be created | `bool` | `false` | no |
| create\_vpc\_origin | If enabled, the resource for VPC origin will be created. | `bool` | `false` | no |
| custom\_domain | If cdn create with custom Domain. | `bool` | `false` | no |
| custom\_error\_response | One or more custom error response elements | `any` | `{}` | no |
| default\_cache\_behavior | The default cache behavior for this distribution | `any` | `null` | no |
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
| geo\_restriction | The restriction configuration for this distribution (geo\_restrictions) | `any` | `{}` | no |
| geo\_restriction\_locations | List of country codes for which  CloudFront either to distribute content (whitelist) or not distribute your content (blacklist). | `list(string)` | `[]` | no |
| geo\_restriction\_type | Method that use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist`. | `string` | `"none"` | no |
| http\_version | The maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3, and http3. The default is http2. | `string` | `"http2"` | no |
| is\_ipv6\_enabled | State of CloudFront IPv6. | `bool` | `true` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| logging\_config | The logging configuration that controls how logs are written to your distribution (maximum one). | `any` | `{}` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| max\_ttl | Maximum amount of time (in seconds) that an object is in a CloudFront cache. | `number` | `31536000` | no |
| min\_ttl | Minimum amount of time that you want objects to stay in CloudFront caches. | `number` | `0` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| ordered\_cache\_behavior | An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0. | `any` | `[]` | no |
| origin | One or more origins for this distribution (multiples allowed). | `any` | `null` | no |
| origin\_access\_control | Map of CloudFront origin access control | <pre>map(object({<br>    description      = string<br>    origin_type      = string<br>    signing_behavior = string<br>    signing_protocol = string<br>  }))</pre> | <pre>{<br>  "s3": {<br>    "description": "",<br>    "origin_type": "s3",<br>    "signing_behavior": "always",<br>    "signing_protocol": "sigv4"<br>  }<br>}</pre> | no |
| origin\_access\_identities | Map of CloudFront origin access identities (value as a comment) | `map(string)` | `{}` | no |
| origin\_group | One or more origin\_group for this distribution (multiples allowed). | `any` | `{}` | no |
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
| retain\_on\_delete | Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. | `bool` | `false` | no |
| smooth\_streaming | Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior. | `bool` | `false` | no |
| staging | Whether the distribution is a staging distribution. | `bool` | `false` | no |
| trusted\_signers | The AWS accounts, if any, that you want to allow to create signed URLs for private content. | `list(string)` | `[]` | no |
| viewer\_certificate | The SSL configuration for this distribution | `any` | <pre>{<br>  "cloudfront_default_certificate": true,<br>  "minimum_protocol_version": "TLSv1"<br>}</pre> | no |
| viewer\_protocol\_policy | Allow-all, redirect-to-https. | `string` | `""` | no |
| vpc\_origin | Map of CloudFront VPC origin | <pre>map(object({<br>    name                   = string<br>    arn                    = string<br>    http_port              = number<br>    https_port             = number<br>    origin_protocol_policy = string<br>    origin_ssl_protocols = object({<br>      items    = list(string)<br>      quantity = number<br>    })<br>  }))</pre> | `{}` | no |
| wait\_for\_deployment | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process. | `bool` | `true` | no |
| web\_acl\_id | Web ACL ID that can be attached to the Cloudfront distribution. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_identity\_ids | The IDS of the origin access identities created |
| arn | The ARN (Amazon Resource Name) for the distribution. |
| domain\_name | The domain name corresponding to the distribution. |
| etag | The current version of the distribution's information. |
| hosted\_zone\_id | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| id | The identifier for the distribution. |
| pubkey\_etag | The current version of the public key. |
| pubkey\_id | The identifier for the public key. |
| status | The current status of the distribution. |
| tags | A mapping of tags to assign to the resource. |

