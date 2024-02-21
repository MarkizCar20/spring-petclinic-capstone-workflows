output "compute_instance_group" {
  value = google_compute_instance_group_manager.webservers.instance_group
}

output "instance_ips" {
  value = [for instance_name in data.google_compute_instance_group_manager.webservers_info.instances : google_compute_instance.instance[instance_name].network_interface.0.access_config[0].nat_ip]
}

