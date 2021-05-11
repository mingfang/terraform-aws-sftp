resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_transfer_user" "transfer_server_user" {
  server_id      = var.server_id
  user_name      = var.user_name
  role           = var.role
  home_directory = format("/%s/%s", var.s3_bucket_id, var.folder)
}

resource "aws_transfer_ssh_key" "transfer_server_ssh_key" {
  server_id = var.server_id
  user_name = aws_transfer_user.transfer_server_user.user_name
  body      = tls_private_key.key.public_key_openssh
}