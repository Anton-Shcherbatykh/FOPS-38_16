# vms_platform.tf - переменные для виртуальных машин

# Переменные для VM_web
variable "vm_web_instance_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "VM instance name for web"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v4a"
  description = "VM platform ID for web"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "VM image family web"
}

# Переменные для VM_db
variable "vm_db_instance_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "VM instance name for db"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v4a"
  description = "VM platform ID for db"
}

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "VM image family db"
}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "VM zone db"
}

variable "vms_resources" {
  description = "Resources for all vms"
  type        = map(map(number))
  default     = {
    vm_web_resources = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
    vm_db_resources = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

variable "common_metadata" {
  description = "metadata for all vms"
  type        = map(string)
  default     = {
    serial-port-enable = "1"
    ssh-keys          = "ubuntu:ssh-ed25519 my pub key"
  }
}