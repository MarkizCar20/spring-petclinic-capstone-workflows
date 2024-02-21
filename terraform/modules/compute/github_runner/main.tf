resource "google_compute_instance" "github_runner" {
  name = "github-runner"
  machine_type = "e2-medium"
  zone = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      
    }
  }

  metadata = {
    ssh-keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN4MPbEDE0xuF9qS9jiuwVGJHKCHgjoSHitUGHNtf/lN mmijailovic@griddynamics.com"
  }

  tags = [ "github-runner" ]
}