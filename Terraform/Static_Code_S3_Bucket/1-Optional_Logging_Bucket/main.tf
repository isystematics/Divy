resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name
  acl    = "log-delivery-write"
}
