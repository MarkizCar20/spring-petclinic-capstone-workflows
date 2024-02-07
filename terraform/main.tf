provider "google" {

    region = "us-central1"
}

resource "google_compute_instance" "demo-instance" {
  name = "demo-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install apache2 -y
    sudo service apache2 start
    echo "Hello from temporary instance!" | sudo tee /var/www/html/index.html
  EOF

  allow_stopping_for_update = true
}