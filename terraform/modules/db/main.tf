

resource "google_compute_instance" "db" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }
  metadata = {
    ssh_key = "appuser:file(var.public_key_path)"
  }
  tags = ["reddit-db"]
  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {
      #nat_ip = google_compute_address.app_ip.address
    }
  }
}

resource "google_compute_firewall" "firewall_mongo" {
         name    = "allow-mongo-default"
         network = "default"
         allow {
           protocol = "tcp"
           ports    = ["27017"]
         }
         # правило применимо к инстансам с тегом ...
         target_tags   = ["reddit-db"]
         # порт будет доступен только для инстансов с тегом ...
         source_tags   = ["reddit-app"]
}
