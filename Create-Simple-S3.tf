provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

resource "aws_s3_bucket" "static_web" {
    bucket = "varin-static-website.com"
    acl    = "private"
    policy = "${file("s3-policy.json")}"
    
    website {
        index_document = "index.html"
    }

    tags = {
        Name    = "Static Bucket"
        Environment = "Pre-Production"
    }
}
