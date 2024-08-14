packer {
  required_plugins {
    proxmox = {
      version = "1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }

    ansible = {
        version = "1.1.1"
        source  = "github.com/hashicorp/ansible"
      }
  }
}
