output "vm_ids" {
  description = "Идентификаторы созданных ВМ"
  value       = docker_container.vm[*].id
}

output "vm_names" {
  description = "Имена ВМ"
  value       = docker_container.vm[*].name
}

output "ip_addresses" {
  description = "IP-адреса ВМ в указанной сети"
  value       = [for vm in docker_container.vm : vm.network_data[0].ip_address]
}

output "disk_ids" {
  description = "Идентификаторы подключаемых дисков"
  value       = docker_volume.disk[*].id
}

output "disk_names" {
  description = "Имена подключаемых дисков"
  value       = docker_volume.disk[*].name
}

output "ssh_host_ports" {
  description = "Порты хоста для SSH"
  value       = [for i in range(var.vm_count) : var.ssh_host_port + i]
}