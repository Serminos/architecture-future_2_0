resource "docker_network" "subnet" {
  name   = "future20-${var.environment}-net"
  driver = "bridge"

  ipam_config {
    subnet = var.subnet_cidr
  }

  labels {
    label = "environment"
    value = var.environment
  }
}

module "vm" {
  source = "../../modules/vm"

  vm_name        = var.vm_name
  vm_count       = var.vm_count
  image          = var.image
  cores          = var.cores
  memory_mb      = var.memory_mb
  disk_size_gb   = var.disk_size_gb
  subnet_id      = docker_network.subnet.name
  ssh_public_key = var.ssh_public_key
  ssh_host_port  = var.ssh_host_port

  labels = {
    environment = var.environment
  }
}