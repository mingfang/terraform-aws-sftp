resource "aws_transfer_user" "transfer_server_user" {
  server_id      = var.server_id
  user_name      = var.user_name
  role           = var.role

  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry = "/"
    target = "/${var.s3_bucket_id}/${var.folder}"
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_transfer_ssh_key" "transfer_server_ssh_key" {
  server_id = var.server_id
  user_name = aws_transfer_user.transfer_server_user.user_name
  body      = tls_private_key.key.public_key_openssh
}

data "local_file" "additional_public_key" {
  count = var.additional_public_key != null ? 1 : 0
  filename = var.additional_public_key
}

resource "aws_transfer_ssh_key" "additional_public_key" {
  count = var.additional_public_key != null ? 1 : 0
  server_id = var.server_id
  user_name = aws_transfer_user.transfer_server_user.user_name
  body      = data.local_file.additional_public_key[0].content
}