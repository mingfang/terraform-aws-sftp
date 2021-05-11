# terraform-aws-sftp
Terraform Module To Create AWS Managed SFTP Server

## Example To Create Users
```terraform
locals {
  folder = "dropbox"
}

module "mingfang" {
  source = "./user"
  user_name = "mingfang"
  role = aws_iam_role.write_only.arn
  server_id = aws_transfer_server.transfer_server_public.id
  s3_bucket_id = aws_s3_bucket.bucket.id
  folder = local.folder
}

resource "local_file" "mingfang" {
  content         = module.mingfang.key.private_key_pem
  filename        = "mingfang.pem"
  file_permission = "0600"
}

module "superuser" {
  source = "./user"
  user_name = "superuser"
  role = aws_iam_role.all.arn
  server_id = aws_transfer_server.transfer_server_public.id
  s3_bucket_id = aws_s3_bucket.bucket.id
  folder = local.folder
}

resource "local_file" "superuser" {
  content         = module.superuser.key.private_key_pem
  filename        = "superuser.pem"
  file_permission = "0600"
}

```