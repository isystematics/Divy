resource "aws_kms_key" "key" {
  count = var.encrypt_bucket ? 1 : 0
  
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "key_alias" {
  count = var.encrypt_bucket ? 1 : 0
  name          = "alias/${var.kms_key_alias}"
  target_key_id = aws_kms_key.key[count.index].key_id
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.main_bucket_name
  acl    = "private"

  dynamic "logging" {
    for_each = var.create_log_bucket ? ["1"] : []
    content {
      target_bucket = var.create_log_bucket ? var.log_bucket_name : null
      target_prefix = var.create_log_bucket ? "log/" : null
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.encrypt_bucket ? ["1"] : []
    content {
      rule {
        apply_server_side_encryption_by_default {
        kms_master_key_id = var.encrypt_bucket ? "${aws_kms_key.key.*.arn[0]}" : null
        sse_algorithm     = var.encrypt_bucket ? "aws:kms" : null
        }
      }
    }
  }
}

resource "aws_iam_user" "user" {
  name = var.iam_username

}

resource "aws_iam_access_key" "key" {
  user    = aws_iam_user.user.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_policy" "s3_access" {
  name = "${var.iam_username}_S3_Access"
  user = aws_iam_user.user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${var.main_bucket_name}",
        "arn:aws:s3:::${var.main_bucket_name}/*"
     ]
    }
  ]
}
EOF
}

resource "aws_iam_user_policy" "kms_access" {
  count = var.encrypt_bucket ? 1 : 0
  name = "${var.iam_username}_KMS_Access"
  user = aws_iam_user.user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kms_key.key.*.arn[0]}"
    }
  ]
}
EOF
}




