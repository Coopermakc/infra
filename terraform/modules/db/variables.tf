#db_disk_image     = "reddit-db"
#public_key_path = "~/.ssh/appuser.pub"

variable "db_disk_image" {
  default = "reddit-db"
}
variable "public_key_path" {}

variable "name" {
  default = "reddit-db"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "machine_type" {
  default = "g1-small"
}
