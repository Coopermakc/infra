variable "region" {}
variable "project" {}
variable "disk_image" {}
variable "public_key_path" {}
variable "private_key" {}

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "europe-west1-b"
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "reddit-base-1579959363"
    }
  }
  metadata = {
    ssh_key = "appuser:file(var.public_key_path)"
  }
  tags = ["reddit-app"]
  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }
  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = file("~/.ssh/appuser")
    host        = var.private_key
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}
resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292", "80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}
