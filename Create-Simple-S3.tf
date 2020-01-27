provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

resource "aws_s3_bucket" "static_web" {
  bucket = "varin-static-website.com"
  acl    = "private"

  tags = {
    Name        = "Static Bucket"
    Environment = "Pre-Production"
  }
}
