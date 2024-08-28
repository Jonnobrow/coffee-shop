resource "proxmox_vm_qemu" "control_plane" {
  count       = 1
  name        = "latte"
  target_node = var.pm_node

  clone = "pckr-tmpl-debian-12"

  os_type  = "cloud-init"
  cores    = 8
  sockets  = "1"
  cpu      = "host"
  memory   = 16384
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disks {
    scsi {
      scsi0 {
        disk {
          iothread = true
          size     = "50G"
          storage  = "local-lvm"
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # cloud-init settings
  ipconfig0 = "ip=192.168.4.5/16,gw=192.168.0.1"

  provisioner "local-exec" {
    command = "ansible-playbook -i ./ansible/inventory.yaml ./ansible/bootstrap.yaml"
  }
}
