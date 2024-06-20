##S3 Bucket configuration 

resource "aws_s3_bucket" "appflow_target_bucket" {
  provider = aws.central
  bucket   = "${var.customer}-target-bucket"
}

resource "aws_s3_bucket_policy" "appflow_target_bucket_s3_policy" {
  provider = aws.central
  bucket   = aws_s3_bucket.appflow_target_bucket.id
  policy   = data.aws_iam_policy_document.s3_policy_target_bucket.json
}

resource "aws_s3_bucket_acl" "source_bucket_acl" {
  provider   = aws.central
  bucket     = aws_s3_bucket.appflow_target_bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  provider = aws.central
  bucket   = aws_s3_bucket.appflow_target_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "target_bucket_versioning" {
  provider = aws.central
  bucket   = aws_s3_bucket.appflow_target_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
