variable "vm_name" {
  description = "Базовое имя ВМ (индекс добавляется автоматически)"
  type        = string
}

variable "vm_count" {
  description = "Количество одинаковых ВМ"
  type        = number
  default     = 1
}

variable "image" {
  description = "Docker-образ (рекомендуется alpine с поддержкой apk)"
  type        = string
  default     = "alpine:3.18"
}

variable "cores" {
  description = "Количество CPU ядер"
  type        = number
}

variable "memory_mb" {
  description = "Объём RAM в мегабайтах"
  type        = number
}

variable "disk_size_gb" {
  description = "Размер диска в ГБ (только как метка тома)"
  type        = number
  default     = 10
}

variable "disk_mount_path" {
  description = "Точка монтирования диска внутри ВМ"
  type        = string
  default     = "/data"
}

variable "subnet_id" {
  description = "ID/имя Docker-сети, в которой работает ВМ"
  type        = string
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ для доступа (root)"
  type        = string
  sensitive   = true
}

variable "ssh_host_port" {
  description = "Начальный порт хоста для проброса SSH (для каждой ВМ увеличивается на индекс)"
  type        = number
  default     = 2222
}

variable "labels" {
  description = "Метки для всех ресурсов"
  type        = map(string)
  default     = {}
}