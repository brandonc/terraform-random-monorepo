resource "aws_s3_bucket" "s3_state_storage" {
  bucket        = var.bucket
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "s3_state_storage_versioning" {
  bucket = aws_s3_bucket.s3_state_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "s3_state_storage_acl" {
  bucket = aws_s3_bucket.s3_state_storage.id
  acl    = "private"
}

output "s3_state_storage" {
  value = aws_s3_bucket.s3_state_storage.id
}
