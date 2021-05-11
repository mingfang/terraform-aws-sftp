output "transfer_server_public" {
  value = aws_transfer_server.transfer_server_public
}

output "s3_bucket" {
  value = aws_s3_bucket.bucket
}

output "all_permissions_role" {
  value = aws_iam_role.all
}

output "write_only_permissions_role" {
  value = aws_iam_role.write_only
}
