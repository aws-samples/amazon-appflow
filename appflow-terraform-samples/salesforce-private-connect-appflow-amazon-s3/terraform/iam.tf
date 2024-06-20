## IAM Resources for Appflow
data "aws_iam_policy_document" "s3_policy_pivot_bucket" {
  statement {
    sid    = "AllowAppFlowDestinationActions"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["appflow.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketAcl",
      "s3:PutObjectAcl",
    ]

    resources = [
      "arn:aws:s3:::${var.customer}-b-pivot",
      "arn:aws:s3:::${var.customer}-b-pivot/*",
    ]
  }
}


## IAM Resources for S3 CRR 

data "aws_kms_key" "s3_key" {
  provider = aws.central
  key_id   = var.encryption_key_central_region
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com", "batchoperations.s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_role_replication" {
  name               = "${var.customer}-iam-role-s3-crr"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "iam_policy_replication" {
  name   = "${var.customer}-iam-policy-s3-crr"
  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment_replication" {
  role       = aws_iam_role.iam_role_replication.name
  policy_arn = aws_iam_policy.iam_policy_replication.arn
}

data "aws_iam_policy_document" "replication" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold",
      "s3:PutInventoryConfiguration"
    ]

    resources = ["${aws_s3_bucket.bucket_pivot.arn}", "${aws_s3_bucket.bucket_centralized.arn}"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]

    resources = ["${aws_s3_bucket.bucket_pivot.arn}/*", "${aws_s3_bucket.bucket_centralized.arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]

    resources = ["${aws_s3_bucket.bucket_pivot.arn}/*", "${aws_s3_bucket.bucket_centralized.arn}/*"]
  }
}

