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
  source_ranges = ["0.0.0.0/0"]
}
