output "transfer_server_public" {
  value = aws_transfer_server.transfer_server_public
}

output "all_permissions_role" {
  value = aws_iam_role.all
}

output "write_only_permissions_role" {
  value = aws_iam_role.write_only
}
