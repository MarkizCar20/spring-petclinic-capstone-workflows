## Global HTTP Load Balancer, configuration of LB resources
variable "instance_group" {}

#Forwarding rule
resource "google_compute_forwarding_rule" "default" {
  name = "global-rule"
  region = "global"
  target = google_compute_target_http_proxy.default.id
  port_range = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

#Target Proxy
resource "google_compute_target_http_proxy" "default" {
  name = "target-proxy"
  description = "description of target proxy"
  url_map = google_compute_url_map.default.id
}

#URL MAP and Routing Rule
resource "google_compute_url_map" "default" {
  name = "url-map-target-proxy"
  description = "url map description"
  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name = "allpaths"
    default_service = google_compute_backend_service.default.id

    path_rule {
      paths = ["/*"]
      service = google_compute_backend_service.default.id
    }
  }
}

resource "google_compute_backend_service" "default" {
    name = "backend"
    port_name = "http"
    protocol = "HTTP"
    timeout_sec = 10
    load_balancing_scheme = "EXTERNAL_MANAGED"
    health_checks = [google_compute_health_check.default1.id]
    backend {
      group = var.instance_group
      balancing_mode = "UTILIZATION"
      max_utilization = 1.0
      capacity_scaler = 1.0
    }
}

resource "google_compute_health_check" "default1" {
    name = "tcp-proxy-health-check1"
    timeout_sec = 1
    check_interval_sec = 1

    tcp_health_check {
      port = "8080"
    }
}