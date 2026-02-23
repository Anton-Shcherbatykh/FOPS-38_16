resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers = yandex_compute_instance.web  # Передаем полные объекты ВМ
      databases  = yandex_compute_instance.db   # Передаем полные объекты ВМ
      storage    = [yandex_compute_instance.storage]  # Передаем полный объект ВМ
    }
  )
  filename = "${abspath(path.module)}/hosts.ini"
}