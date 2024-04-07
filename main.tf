#Random string
resource "random_string" "random_name" {
  length  = 16
  special = false
  numeric = false
  lower   = true
  upper   = false
}

#S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "public-website-s3-hosting-${random_string.random_name.result}"
}

#S3 public access block
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


#S3 bucket policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": ["${aws_s3_bucket.s3_bucket.arn}","${aws_s3_bucket.s3_bucket.arn}/*" ]
    }
  ]
}
EOF
}

#S3 bucket website configuration

resource "aws_s3_bucket_website_configuration" "s3_web_config" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

#S3 index object page
resource "aws_s3_object" "index_page" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}
# error object page

resource "aws_s3_object" "error_page" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
}
