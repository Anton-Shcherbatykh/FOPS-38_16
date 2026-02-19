# Создание сети
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

# Создание подсети в зоне ru-central1-a
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone_web
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

# Создание подсети в зоне ru-central1-b
resource "yandex_vpc_subnet" "develop_db" {
  name           = "${var.vpc_name}-db"
  zone           = var.default_zone_db
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

# Ресурсы для ВМ web
data "yandex_compute_image" "ubuntu_web" {
  family = var.vm_web_family
}

resource "yandex_compute_instance" "platform_web" {
  name        = local.vm_web_instance_name
  platform_id = var.vm_web_platform_id
  zone        = var.default_zone_web
  
  resources {
    cores         = var.vms_resources["vm_web_resources"]["cores"]
    memory        = var.vms_resources["vm_web_resources"]["memory"]
    core_fraction = var.vms_resources["vm_web_resources"]["core_fraction"]
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_web.image_id
      size     = 20
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = var.common_metadata

}

# Ресурсы для ВМ db
data "yandex_compute_image" "ubuntu_db" {
  family = var.vm_db_family
}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_instance_name
  platform_id = var.vm_db_platform_id
  zone        = var.default_zone_db
  
  resources {
    cores         = var.vms_resources["vm_db_resources"]["cores"]
    memory        = var.vms_resources["vm_db_resources"]["memory"]
    core_fraction = var.vms_resources["vm_db_resources"]["core_fraction"]
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_db.image_id
      size     = 20
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = var.main_nat
  }
}
