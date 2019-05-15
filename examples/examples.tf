provider "aws" {
  region  = "eu-west-2"
  profile = "defult"
}
module "cdn" {
  source = "https://github.com/clouddrove/terraform-aws-cloudfront-cdn-secure.git"
  organization             =    "clouddrove"
  environment              =    "dev"
  name                     =    "backend"
  aliases                  =    ["xyz.com"]
  origin_id                =    "s3-secure-bucket"
  viewer_protocol_policy   =    "redirect-to-https"
  compress                 =    "false"
  trusted_signers          = [65665959196, ] #aws account number
  allowed_methods               =  ["GET", "HEAD" ]
  acm_certificate_arn       =  "arn:aws:acm:us-east-1:870902197131:certificate/d67e427c-ec3b-4ecb-9f4a-xxxxx"

}


