#app_disk_image     = "reddit-app"
#public_key_path = "~/.ssh/appuser.pub"


variable "app_disk_image" {
  default = "reddit-app"
}
variable "public_key_path" {}

variable "name" {
  default = "reddit-app"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "machine_type" {
  default = "g1-small"
}
