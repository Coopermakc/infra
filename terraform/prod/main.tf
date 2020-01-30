variable "region" {}
variable "project" {}
variable "disk_image" {}
variable "public_key_path" {}
variable "private_key" {}
variable "app_disk_image" {}
variable "db_disk_image" {}

provider "google" {
  project = var.project
  region  = var.region
}

module "app" {
  source = "../modules/app"
  public_key_path = var.public_key_path
  app_disk_image = var.app_disk_image
}

module "db" {
  source = "../modules/db"
  public_key_path = var.public_key_path
  db_disk_image = var.db_disk_image
}

module "vpc" {
  source = "../modules/vpc"
  source_ranges = var.source_ranges
}

# resource "google_compute_instance" "app" {
#   name         = "reddit-app"
#   machine_type = "g1-small"
#   zone         = "europe-west1-b"
#   # определение загрузочного диска
#   boot_disk {
#     initialize_params {
#       image = "reddit-base-1579959363"
#     }
#   }
#   metadata = {
#     ssh_key = "appuser:file(var.public_key_path)"
#   }
#   tags = ["reddit-app"]
#   # определение сетевого интерфейса
#   network_interface {
#     # сеть, к которой присоединить данный интерфейс
#     network = "default"
#     # использовать ephemeral IP для доступа из Интернет
#     access_config {
#       nat_ip = google_compute_address.app_ip.address
#     }
#   }
#   connection {
#     type        = "ssh"
#     user        = "appuser"
#     agent       = false
#     private_key = file("~/.ssh/appuser")
#     host        = google_compute_address.app_ip.address
#   }
#   provisioner "file" {
#     source      = "files/puma.service"
#     destination = "/tmp/puma.service"
#   }
#   provisioner "remote-exec" {
#     script = "files/deploy.sh"
#   }
# }
#
# resource "google_compute_address" "app_ip" {
#              name = "reddit-app-ip"
# }
#
# resource "google_compute_firewall" "firewall_puma" {
#   name    = "allow-puma-default"
#   network = "default"
#
#   allow {
#     protocol = "tcp"
#     ports    = ["9292", "80"]
#   }
#   source_ranges = ["0.0.0.0/0"]
#   target_tags   = ["reddit-app"]
# }
#
# resource "google_compute_firewall" "firewall-ssh" {
#     name = "default-allow-ssh"
#     network = "default"
#     allow {
#       protocol = "tcp"
#       ports = ["22"]
#     }
#
#     source_ranges = ["0.0.0.0/0"]
# }
