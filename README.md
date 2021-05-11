# terraform-aws-sftp
Terraform Module To Create AWS Managed SFTP Server

## Example To Create Users
```terraform
/* Create SFTP Server */

module "sftp" {
  source = "git::https://github.com/mingfang/terraform-aws-sftp.git"
}

/* Users */

locals {
  folder = "dropbox"
}

module "mingfang" {
  source = "git::https://github.com/mingfang/terraform-aws-sftp.git//user"
  user_name = "mingfang"
  role = module.sftp.write_only_permissions_role.arn
  server_id = module.sftp.transfer_server_public.id
  s3_bucket_id = module.sftp.s3_bucket.id
  folder = local.folder
}

resource "local_file" "mingfang" {
  content         = module.mingfang.key.private_key_pem
  filename        = "mingfang.pem"
  file_permission = "0600"
}

module "superuser" {
  source = "git::https://github.com/mingfang/terraform-aws-sftp.git//user"
  user_name = "superuser"
  role = module.sftp.all_permissions_role.arn
  server_id = module.sftp.transfer_server_public.id
  s3_bucket_id = module.sftp.s3_bucket.id
  folder = local.folder
}

resource "local_file" "superuser" {
  content         = module.superuser.key.private_key_pem
  filename        = "superuser.pem"
  file_permission = "0600"
}
```