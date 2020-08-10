output "bucket_name" {
  description = "Bucket Name"
  value       = aws_s3_bucket.bucket.id
}

output "access_key_id" {
  value = aws_iam_access_key.key.id
}

output "secret_access_key" {
  value = aws_iam_access_key.key.encrypted_secret
}