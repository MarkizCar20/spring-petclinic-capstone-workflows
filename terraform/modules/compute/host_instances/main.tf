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
    ssh-keys = <<-EOT
      ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYizdDimuLVxllNaVR/qwiRp+PmcimF0r878ckVPF7QVWmzzPliiXyy1QrLGsBzsHD2384LQdTdyDaHmbd1XwXR31SvpbFlAM/CO2/UKmWkMYrJdvx58JqvwQdHEHCITSA3dffLs0a1Q5XqmwyA3YDc8Q3MshXy3Gv2FmlfgpexFBQyvPAt3fOTyZ4+rDdaXi6f/t9VAlTnpUswcnLrhhdonLFVZWQflP8obY+5+5T5lcZ7raSAfy4BjXFPUJ97V/DgfR6WhNgNL6whA3EUZJ9Xt6KvV4VhNVNZOLR1KTD97Nk8jRXBR3g6WA36x7eHH+VWNXRFQSrXRgLB3E75jOFnDBsTxTjRurpN9lJXgMicMV4DfWaYbfwYP1ekM/cTYupn5j6v+f7H7w/MG60+ZssEQou1OyuYbo/VuwLXSXxENZZl78Bjdy2OcN2WQAexEcTl/exSx40nzOCUFjVFuVXYUqx40Uo52f3/wuJ7QAc5eFcGEwQ9st7hwDJ1u9klz4f3Qiz50mLgL90u4AtOyo9XTyP0++LpihoteGXE3ZERVQlx3/0finS6sD9n/QLA6XoEf6/dwyzC0IBdeb94lftKLapYo00YjcEJYEDbNsNRW/3NjdMGTewLT3xj/jpv64olppvyez6BIrYkXbb8fZyGtp2pdAeG0ISwV99YpLqIw== mijailovicmarko2000@github-runner-2
      ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC27DEQmygxeGZ9QkWCr8ofJtmv1ADxddg+eZ93Nv0SNIL8ZclNRPXxgmHI0gpCAt2ctm4Vj9gtFvEdBQAIISyrWdZmS5In3nlbizE/yb9liwDtn428Yc1B1jwF0+2iVvSd4RF6qU4GzAU6lq/1rRCfBq/govXpYUWjTBpze7idUHdh/syt1aPGo/PSJvsJEe+VygUTPR2hT7wEv5Vh6bMpwOnfJYRzrlVREm2X6E4DWPPTO+HSD3ur8F8nrQSPtA6nnjC+4OeeuagkvT4iH4usGFu+7HU6zaA8ORG+dNfFpYEmcI1YgCv3FUrhptZ+pJ2s9ee/JnTaLlqTLDMWdufN3g9F6zCTtKeoP6SKo/fxhTj1ELTtNk28dpwyoG4U+5ojT9yFJD0WXd6xbgXmKU+X0MQdoY/ttuFR5VfUkHv4dwineZMZ3s4qjX9zcujbVTMP5kIVZz9VUyGfxzjvf9IAqGxC6zgCewKGNA9s0kLlFhM6Cswa9I8H5n1/hRubpdjgl5iR7ay7BfZCvGAFvGEbiRohWoKgElxoUuhS0HMdpeiJGv6bCgwa+kNd/7qPuauKecXNnrR/+CzSjnPj80esBy4y1RaS8XGYv9/5Mjl9WzLbjEWxUKUw1/02rH17YZ00WYUmNwaZ2DL4dLy1hyPIOBNORifQs1sWDZ+rxiT2QQ== mijailovicmarko2000@github-runner
    EOT
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
    max_replicas = 1
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
    ports = ["80", "8080"]
    protocol = "tcp"
  }
  source_ranges = ["0.0.0.0/0"]
}
