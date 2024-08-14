variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.6.0-amd64-netinst.iso"
}

variable "iso_storage_pool" {
  type    = string
}

variable "iso_checksum" {
  type    = string
  default = "sha512:712cf43c5c9d60dbd5190144373c18b910c89051193c47534a68b0cd137c99bd8274902f59b25aba3b6ba3e5bca51d7c433c06522f40adb93aacc5e21acf57eb"
}

variable "vmid" {
  type = string
  description = "Proxmox Template ID"
}

variable "cpu_type" {
  type    = string
  default = "x86-64-v2-AES"
}

variable "cores" {
  type    = string
  default = "2"
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_size" {
  type    = string
  default = "16G"
}

variable "storage_pool" {
  type    = string
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "proxmox_api_password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "proxmox_api_user" {
  type    = string
  default = ""
}

variable "proxmox_host" {
  type    = string
  default = ""
}

variable "proxmox_node" {
  type    = string
  default = ""
}
