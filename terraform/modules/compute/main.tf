resource "google_compute_instance_template" "group_instance" {
  name = "instance-template"

  machine_type = "e2-small"
  disk {
    source_image = "debian-cloud/debian-10"
  }

  network_interface {
    network = "default"
    #Access config for ephemeral public IP If needed
  }

  metadata_startup_script = file("./modules/compute/web1.sh")
}

#INSTANCE GROUP 1
resource "google_compute_instance_group_manager" "webservers" {
  name = "terraform-webservers-us"
  base_instance_name = "instance-x"
  description = "terraform test instance group"
  zone = "us-central1-c"

  target_size = 1

  version {
    instance_template = google_compute_instance_template.group_instance.id
  }

  named_port {
    name = "http"
    port = "80"
  }
}

resource "google_compute_autoscaler" "group_autoscaler" {
  name = "group-autoscaler"
  target = google_compute_instance_group_manager.webservers.self_link

  zone = "us-central1-c"

  autoscaling_policy {
    max_replicas = 10
    min_replicas = 1
    cooldown_period = 60
    
    cpu_utilization {
      target = 0.5
    }
  }
}

#to allow http traffic to the instances
resource "google_compute_firewall" "default" {
  name = "allow-http-traffic"
  network = "default"
  allow {
    ports = ["80"]
    protocol = "tcp"
  }
  source_ranges = ["0.0.0.0/0"]
}