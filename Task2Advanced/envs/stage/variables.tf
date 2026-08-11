variable "environment" {
  description = "Имя окружения"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR-подсеть"
  type        = string
}

variable "vm_name" {
  description = "Базовое имя ВМ"
  type        = string
}

variable "vm_count" {
  description = "Количество ВМ"
  type        = number
}

variable "image" {
  description = "Docker-образ"
  type        = string
  default     = "alpine:3.18"
}

variable "cores" {
  description = "Количество CPU ядер"
  type        = number
}

variable "memory_mb" {
  description = "RAM в мегабайтах"
  type        = number
}

variable "disk_size_gb" {
  description = "Размер диска в ГБ"
  type        = number
}

variable "ssh_host_port"  {
  type        = number
}

variable "ssh_password"   {
  type        = string
  sensitive   = true
}

variable "minio_endpoint" {
  description = "MinIO endpoint (e.g., http://minio:9000)"
  type        = string
  sensitive   = true
}
variable "minio_bucket" {
  description = "Bucket for Terraform state"
  type        = string
}
variable "minio_access_key" {
  description = "MinIO access key"
  type        = string
  sensitive   = true
}
variable "minio_secret_key" {
  description = "MinIO secret key"
  type        = string
  sensitive   = true
}