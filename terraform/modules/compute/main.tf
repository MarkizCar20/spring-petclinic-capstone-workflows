module "github_runner" {
  source = "./github_runner"
}

module "host_instances" {
  source = "./host_instances"
}

output "compute_instance_group" {
  value = host_instances.compute_instance_group
}