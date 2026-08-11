output "environment" {
  value = var.environment
}

output "network" {
  value = docker_network.subnet.name
}

output "vm_names" {
  value = module.vm.vm_names
}

output "ip_addresses" {
  value = module.vm.ip_addresses
}

output "ssh_host_ports" {
  value = module.vm.ssh_host_ports
}