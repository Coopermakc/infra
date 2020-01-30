


resource "google_compute_instance" "app" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.app_disk_image
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
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }
  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = file("~/.ssh/appuser")
    host        = google_compute_address.app_ip.address
  }
  # provisioner "remote-exec"{
  #   script = "files/install_ruby.sh"
  # }
  provisioner "file" {
    source      = "../files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "../files/deploy.sh"
  }
}

resource "google_compute_address" "app_ip" {
    name = "reddit-app-ip"
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
