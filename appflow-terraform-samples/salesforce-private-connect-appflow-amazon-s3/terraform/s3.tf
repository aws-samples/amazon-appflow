## Pivot S3 Bucket configuration 

resource "aws_s3_bucket" "bucket_pivot" {
  provider = aws.pivot
  bucket   = "${var.customer}-b-pivot"
}

resource "aws_s3_bucket_policy" "pivot_s3_policy" {
  provider = aws.pivot
  bucket   = aws_s3_bucket.bucket_pivot.id
  policy   = data.aws_iam_policy_document.s3_policy_pivot_bucket.json
}

resource "aws_s3_bucket_acl" "source_bucket_acl" {
  provider   = aws.pivot
  bucket     = aws_s3_bucket.bucket_pivot.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  provider = aws.pivot
  bucket   = aws_s3_bucket.bucket_pivot.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "bucket_pivot_versioning" {
  provider = aws.pivot
  bucket   = aws_s3_bucket.bucket_pivot.id
  versioning_configuration {
    status = "Enabled"
  }
}

## Centralized S3 Bucket configuration 
resource "aws_s3_bucket" "bucket_centralized" {
  provider = aws.central
  bucket   = "${var.customer}-b-centralized"
}

resource "aws_s3_bucket_versioning" "bucket_centralized_versioning" {
  provider = aws.central
  bucket   = aws_s3_bucket.bucket_centralized.id
  versioning_configuration {
    status = "Enabled"
  }
}

## CRR Configuration
resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.pivot
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.bucket_pivot_versioning]

  role   = aws_iam_role.iam_role_replication.arn
  bucket = aws_s3_bucket.bucket_pivot.id

  rule {
    id = "${var.customer}-b-crr-centralized"
    filter {

    }
    status = "Enabled"
    delete_marker_replication {
      status = "Disabled"
    }

    source_selection_criteria {
      replica_modifications {
        status = "Enabled"
      }
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }


    destination {
      bucket = aws_s3_bucket.bucket_centralized.arn
      replication_time {
        status = "Enabled"
        time {
          minutes = var.replication_time_minutes
        }
      }
      metrics {
        status = "Enabled"
        event_threshold {
          minutes = var.metric_replication_minutes
        }
      }
      encryption_configuration {
        replica_kms_key_id = data.aws_kms_key.s3_key.arn
      }
    }
  }
}