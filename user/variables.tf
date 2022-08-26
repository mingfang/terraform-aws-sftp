variable "user_name" {}
variable "role" {}

variable "server_id" {}

variable "s3_bucket_id" {}
variable "folder" {}

variable "additional_public_key" {
  default = null
  description = "example: ssh-keygen -t rsa -b 4096 -f additional_key"
}