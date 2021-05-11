/* Create SFTP Server */

resource "aws_transfer_server" "transfer_server_public" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = aws_iam_role.logging.arn
  endpoint_type          = "PUBLIC"
  protocols              = ["SFTP"]
}

/* Create S3 Bucket */

resource "aws_s3_bucket" "bucket" {
  bucket = "sftp-${aws_transfer_server.transfer_server_public.id}"
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/* Grant Permission To Log */

data "aws_iam_policy_document" "logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "logging" {
  name               = "sftp_logging"
  assume_role_policy = data.aws_iam_policy_document.transfer_server_assume_role.json
}

resource "aws_iam_role_policy" "logging" {
  name   = "transfer_server_logging"
  role   = aws_iam_role.logging.name
  policy = data.aws_iam_policy_document.logging.json
}

/* Grant Role To AWS Transfer Service */

data "aws_iam_policy_document" "transfer_server_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

/* Grant Permission To Access S3 */

data "aws_iam_policy_document" "write_only" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "write_only" {
  name               = "sftp_${aws_transfer_server.transfer_server_public.id}_write_only"
  assume_role_policy = data.aws_iam_policy_document.transfer_server_assume_role.json
}

resource "aws_iam_role_policy" "write_only" {
  name   = "write_only"
  role   = aws_iam_role.write_only.name
  policy = data.aws_iam_policy_document.write_only.json
}

data "aws_iam_policy_document" "all" {
  statement {
    effect = "Allow"

    actions = ["s3:*"]

    resources = ["*"]
  }
}

resource "aws_iam_role" "all" {
  name               = "sftp_${aws_transfer_server.transfer_server_public.id}_all"
  assume_role_policy = data.aws_iam_policy_document.transfer_server_assume_role.json
}

resource "aws_iam_role_policy" "all" {
  name   = "all"
  role   = aws_iam_role.all.name
  policy = data.aws_iam_policy_document.all.json
}
