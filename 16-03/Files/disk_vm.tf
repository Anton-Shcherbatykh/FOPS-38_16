# Создание трёх дополнительных накопителей
resource "yandex_compute_disk" "storage_disks" {
  count = 3
  
  name       = "storage-disk-${count.index + 1}"
  type       = "network-hdd"
  zone       = var.default_zone
  size       = 1
  image_id   = ""  # Пустой image_id для создания пустого диска
  
  lifecycle {
    prevent_destroy = false
  }
}

# Создание ВМ "storage" с подключением созданных дисков
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd85qmcpsmrrg53l9082"
      size     = 10
    }
  }

  dynamic "secondary_disk" {
    for_each = { for idx, disk in yandex_compute_disk.storage_disks : idx => disk }
    content {
      disk_id = secondary_disk.value.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.main_nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${local.ssh_key}"
  }
}
