output "VMs" {
  value = {
    instance_name1 = yandex_compute_instance.platform_web.name
    external_ip1 = yandex_compute_instance.platform_web.network_interface.0.nat_ip_address
    instance_name2 = yandex_compute_instance.platform_db.name
    external_ip2 = yandex_compute_instance.platform_db.network_interface.0.nat_ip_address
  }
}
