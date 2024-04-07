//Website url
output "website_url" {
  value = aws_s3_bucket_website_configuration.s3_web_config.website_endpoint
}


//Bucket name when documents are hosted
output "bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}
