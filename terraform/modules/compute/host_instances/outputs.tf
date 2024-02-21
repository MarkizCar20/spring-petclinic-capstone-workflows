output "compute_instance_group" {
  value = google_compute_instance_group_manager.webservers.instance_group
}

output "instance_ips" {
  value = google_compute_instance_group_manager.webservers.instance_template.*.network_interface.0.access_config.0.nat_ip
}
