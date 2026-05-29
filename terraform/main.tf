resource "yandex_vpc_network" "net" { 
    name = "my-net"
    
    }
resource "yandex_vpc_subnet" "sub" { 
  name           = "my-sub"
  zone        = var.zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

# Image OS
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

#Disk for bastion
resource "yandex_compute_disk" "boot_disk_clickhouse" {
  image_id = var.image_id
  type     = var.boot_disk.disk.disk_type
  size     = var.boot_disk.disk.disk_size
  zone        = var.zone
}

# Disk for zone A
resource "yandex_compute_disk" "boot_disk_vector" {
  image_id = var.image_id
  type     = var.boot_disk.disk.disk_type
  size     = var.boot_disk.disk.disk_size
  zone        = var.zone
}

#Disk for zone B
resource "yandex_compute_disk" "boot_disk_lighthouse" {
  image_id = var.image_id
  type     = var.boot_disk.disk.disk_type
  size     = var.boot_disk.disk.disk_size
  zone        = var.zone
}

resource "yandex_compute_instance" "clickhouse" {
  name        = "vm-clickhouse"
  platform_id = "standard-v3"
  zone        = var.zone
  
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  
  boot_disk {
      disk_id = yandex_compute_disk.boot_disk_clickhouse.id
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.sub.id
    nat       = var.nat
  }
  
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }
}

resource "yandex_compute_instance" "vector" {
  name        = "vm-vector"
  platform_id = "standard-v3"
  zone        = var.zone
  
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  
  boot_disk {
    disk_id = yandex_compute_disk.boot_disk_vector.id
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.sub.id
    nat       = var.nat
  }
  
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }
}


resource "yandex_compute_instance" "lighthouse" {
  name        = "vm-lighthouse"
  platform_id = "standard-v3"
  zone        = var.zone
  
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  
  boot_disk {
    disk_id = yandex_compute_disk.boot_disk_lighthouse.id
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.sub.id
    nat       = var.nat
  }
  
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }
}


output "ip_vector" {
  value = yandex_compute_instance.vector.network_interface.0.nat_ip_address
}

output "ip_clickhouse" {
  value = yandex_compute_instance.clickhouse.network_interface.0.nat_ip_address
}

output "ip_lighthouse" {
  value = yandex_compute_instance.lighthouse.network_interface.0.nat_ip_address
}