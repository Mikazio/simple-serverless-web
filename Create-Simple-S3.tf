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
    Name        = "Static Bucket"
    Environment = "Pre-Production"
  }
}

resource "null_resource" "output_id" {
  provisioner "local-exec" {
    command = "aws s3 sync s3://wildrydes-us-east-1/WebApplication/1_StaticWebHosting/website s3://varin-static-website.com --region ap-southeast-1"
  }
    depends_on = ["aws_s3_bucket.static_web"]
}
