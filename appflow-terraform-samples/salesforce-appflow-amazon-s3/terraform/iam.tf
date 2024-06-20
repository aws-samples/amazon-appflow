## IAM Resources for Appflow
data "aws_iam_policy_document" "s3_policy_target_bucket" {
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
      aws_s3_bucket.appflow_target_bucket.arn,
      "${aws_s3_bucket.appflow_target_bucket.arn}/*",
    ]
  }
}

