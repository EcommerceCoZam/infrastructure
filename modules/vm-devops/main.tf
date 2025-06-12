# IP estática reservada para la VM DevOps (opcional pero recomendado)
resource "google_compute_address" "devops_static_ip" {
  count   = var.reserve_static_ip ? 1 : 0
  name    = "${var.vm_name}-static-ip"
  region  = var.region
  project = var.project_id
}

resource "google_compute_instance" "devops_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  tags = var.network_tags

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  network_interface {
    network    = var.create_network ? google_compute_network.devops_network[0].id : var.network_name
    subnetwork = var.create_network ? google_compute_subnetwork.devops_subnetwork[0].id : var.subnetwork_name

    dynamic "access_config" {
      for_each = var.enable_external_ip ? [1] : []
      content {
        # Usar IP estática si se reservó, sino dinámica
        nat_ip = var.reserve_static_ip ? google_compute_address.devops_static_ip[0].address : null
      }
    }
  }

  # SSH Keys para múltiples usuarios
  metadata = {
    ssh-keys = join("\n", [
      for user_key, user_data in var.ssh_users :
      "${user_data.username}:${user_data.public_key}"
    ])
  }

  # Script de inicialización básico
  metadata_startup_script = var.startup_script

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  labels = var.labels

  # Permitir HTTP y HTTPS traffic
  allow_stopping_for_update = true
}

# Firewall rules para acceso a servicios DevOps
resource "google_compute_firewall" "devops_services" {
  name    = "${var.vm_name}-devops-services"
  network = var.create_network ? google_compute_network.devops_network[0].id : var.network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = var.allowed_ports
  }

  source_ranges = var.source_ip_ranges
  target_tags   = var.network_tags
}

# Firewall rule para SSH
resource "google_compute_firewall" "ssh" {
  name    = "${var.vm_name}-ssh"
  network = var.create_network ? google_compute_network.devops_network[0].id : var.network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges
  target_tags   = var.network_tags
}

# Crear red si no existe
resource "google_compute_network" "devops_network" {
  count                   = var.create_network ? 1 : 0
  name                    = var.network_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "devops_subnetwork" {
  count         = var.create_network ? 1 : 0
  name          = var.subnetwork_name
  ip_cidr_range = var.subnetwork_cidr
  region        = var.region
  network       = google_compute_network.devops_network[0].id
  project       = var.project_id
}
