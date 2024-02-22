resource "google_compute_instance_template" "group_instance" {
  name = "instance-template"

  machine_type = "e2-medium"
  disk {
    source_image = "debian-cloud/debian-10"
    disk_size_gb = 50
  }

  network_interface {
    network = "default"
    access_config {
      // Optional: Ephemeral external IP address
    }
  }

  metadata = {
    ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC27DEQmygxeGZ9QkWCr8ofJtmv1ADxddg+eZ93Nv0SNIL8ZclNRPXxgmHI0gpCAt2ctm4Vj9gtFvEdBQAIISyrWdZmS5In3nlbizE/yb9liwDtn428Yc1B1jwF0+2iVvSd4RF6qU4GzAU6lq/1rRCfBq/govXpYUWjTBpze7idUHdh/syt1aPGo/PSJvsJEe+VygUTPR2hT7wEv5Vh6bMpwOnfJYRzrlVREm2X6E4DWPPTO+HSD3ur8F8nrQSPtA6nnjC+4OeeuagkvT4iH4usGFu+7HU6zaA8ORG+dNfFpYEmcI1YgCv3FUrhptZ+pJ2s9ee/JnTaLlqTLDMWdufN3g9F6zCTtKeoP6SKo/fxhTj1ELTtNk28dpwyoG4U+5ojT9yFJD0WXd6xbgXmKU+X0MQdoY/ttuFR5VfUkHv4dwineZMZ3s4qjX9zcujbVTMP5kIVZz9VUyGfxzjvf9IAqGxC6zgCewKGNA9s0kLlFhM6Cswa9I8H5n1/hRubpdjgl5iR7ay7BfZCvGAFvGEbiRohWoKgElxoUuhS0HMdpeiJGv6bCgwa+kNd/7qPuauKecXNnrR/+CzSjnPj80esBy4y1RaS8XGYv9/5Mjl9WzLbjEWxUKUw1/02rH17YZ00WYUmNwaZ2DL4dLy1hyPIOBNORifQs1sWDZ+rxiT2QQ== mijailovicmarko2000@github-runner"
  }

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
