resource "docker_image" "this" {
  name         = var.image
  keep_locally = true
}

resource "docker_volume" "disk" {
  count = var.vm_count
  name  = "${var.vm_name}-${count.index}-disk"

  labels {
    label = "managed-by"
    value = "terraform"
  }
  labels {
    label = "disk_size_gb"
    value = tostring(var.disk_size_gb)
  }
  labels {
    label = "environment"
    value = var.labels["environment"]
  }
}

resource "docker_container" "vm" {
  count = var.vm_count
  name  = "${var.vm_name}-${count.index}"
  image = docker_image.this.image_id

  memory     = var.memory_mb
  cpu_shares = var.cores * 1024
  restart    = "unless-stopped"

  networks_advanced {
    name = var.subnet_id
  }

  volumes {
    volume_name    = docker_volume.disk[count.index].name
    container_path = var.disk_mount_path
  }

  command = [
    "/bin/sh", "-c",
    "apk add --no-cache openssh-server && ssh-keygen -A && echo 'root:${var.ssh_password}' | chpasswd && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && /usr/sbin/sshd && tail -f /dev/null"
  ]

  ports {
    internal = 22
    external = var.ssh_host_port + count.index
  }

  dynamic "labels" {
    for_each = merge(var.labels, {
      cores     = tostring(var.cores)
      memory_mb = tostring(var.memory_mb)
    })
    content {
      label = labels.key
      value = labels.value
    }
  }
}