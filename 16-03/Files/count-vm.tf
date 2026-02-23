# Создание двух ВМ для web с помощью count (зависят от ВМ БД)
resource "yandex_compute_instance" "web" {
  count = 2
  
  depends_on = [yandex_compute_instance.db]
  
  name        = "web-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores         = var.vms_web_resources.cores
    memory        = var.vms_web_resources.memory
    core_fraction = var.vms_web_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = "fd85qmcpsmrrg53l9082"  # Ubuntu 22.04 LTS
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.main_nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = merge(var.common_metadata, {
    ssh-keys = "ubuntu:${local.ssh_key}"
  })
}