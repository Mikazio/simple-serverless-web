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

resource "aws_cognito_identity_pool" "user" {
    identity_pool_name               = "user_pool"
    allow_unauthenticated_identities = false
}

resource "aws_cognito_user_pool" "user_pool" {
  name                     = "user_pool"
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_identity_provider" "provider" {
  user_pool_id  = "${aws_cognito_user_pool.user_pool.id}"
  provider_name = "Facebook"
  provider_type = "Facebook"

  provider_details = {
    authorize_scopes = "email"
    client_id        = "your client_id"
    client_secret    = "your client_secret"
  }

  attribute_mapping = {
    email    = "email"
  }
}

resource "null_resource" "output_id" {
  provisioner "local-exec" {
    command = "aws s3 sync s3://wildrydes-us-east-1/WebApplication/1_StaticWebHosting/website s3://varin-static-website.com --region ap-southeast-1"
  }
    depends_on = ["aws_s3_bucket.static_web"]
}
