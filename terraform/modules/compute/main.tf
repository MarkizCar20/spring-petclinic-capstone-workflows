#INSTANCE GROUP 1
resource "google_compute_instance_groups" "webservers" {
  name = "terraform-webservers-us"
  description = "terraform test instance group"
  zone = "us-central1-c"

  instances = [
    google_compute_instance.default.id
  ]
  named_port {
    name = "http"
    port = "80"
  }
}

resource "google_compute_instance" "default" {
  name = "web1"
  machine_type = "f1-micro"
  zone = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
  metadata_startup_script = file("web1.sh")
}

#to allow http traffic to the instances
resource "google_compute_firewal" "default" {
  name = "allow-http-traffic"
  network = "default"
  allow {
    ports = ["80"]
    protocol = "tcp"
  }
  source_ranges = ["0.0.0.0/0"]
}