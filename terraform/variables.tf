###cloud vars

variable "folder_id" {
  description = "(Optional) - Yandex Cloud Folder ID where resources will be created."
  type        = string
  default = "ao7ihlsmnbkksivf0n02"
}

variable "cloud_id" {
    type = string
    default = "ao7v9tig1s0v6trerpgk"
}

variable "zone" {
  type = string
  default = "kz1-a"
}

variable "name_prefix" {
  description = "(Optional) - Name prefix for project."
  type        = string
  default     = "project"
}

variable "boot_disk_name" {
  description = "(Optional) - Name of the boot disk."
  type        = string
  default     = null
}

variable "boot_disk" {
  type = object({
    disk = object({
      disk_type = string
      disk_size = number
    })
  })

  default = {
    disk = {
      disk_type = "network-ssd"
      disk_size = 15
    }
  }
}

variable "instance_resources" {
    type = object({
      cores = number
      memory = number
      core_fraction = number
    })

    default = {
      cores = 2
      memory = 2
      core_fraction = 20
    }
}

variable "platform_id" {
    description = "Name of zone"
    type = string
    default = "standard-v3"
}

variable "linux_vm_name" {
  description = "(Optional) - Name of the Linux VM."
  type        = string
  default     = null
}

variable "image_id" {
  description = "(Optional) - Boot disk image id. If not provided, it defaults to Ubuntu 22.04 LTS image id"
  type        = string
  default     = "fbn04s40kver1bbbn4ms"
}

variable "vpc_network_name" {
  description = "(Optional) - Name of the VPC network."
  type        = string
  default     = null
}

variable "nat" {
  type = bool
  default = true
}