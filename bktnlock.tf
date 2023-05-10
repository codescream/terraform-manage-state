provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "terraform-state-bkt" {
    bucket = "terraform-state-rukkie-bkt"

    #force_destroy = true

    #prevent accidental deletion of bucket
    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "s3-version" {
    bucket = aws_s3_bucket.terraform-state-bkt.id

    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-encrypt" {
    bucket = aws_s3_bucket.terraform-state-bkt.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_s3_bucket_public_access_block" "s3-bkt-pub-block" {
  bucket = aws_s3_bucket.terraform-state-bkt.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "aws_s3_bucket_arn" {
  value = aws_s3_bucket.terraform-state-bkt.arn
  description = "The ARN of the s3 bucket"
}

output "aws_dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "the name of the dynamodb table"
}