terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=1.0.0"
    }
  }
  required_version = ">= 0.14"
}

provider "proxmox" {
  pm_api_url = "https://${var.pve_ip_address}:8006/api2/json"
  pm_user =var.pm_user
  pm_password =var.pm_password
  pm_log_file   = "terraform-plugin-proxmox.log"
 
}

resource "proxmox_vm_qemu" "front_virtual_machine" {
  count = 2
  name = "web${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template
  os_type = "cloud-init"
  agent = 1
  cores = 2
  sockets = "1"
  memory = 2048
  cpu = "host"
  scsihw = "virtio-scsi-pci"
  bootdisk = "virtio0"

disk {
    slot = 0
    size = "10G"
    type = "virtio"
    storage = var.storage
}



network {
    model           = "virtio"
    bridge          = "vmbr0"
}

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

# Cloud Init Settings
ipconfig0 = "ip=192.168.56.1${count.index + 1}/24,gw=192.168.56.1"
 ssh_user = "ubuntu" 
 sshkeys = var.ssh_keys


}
resource "proxmox_vm_qemu" "backend_virtual_machine" {
  count = 2
  name = "back${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template
  os_type = "cloud-init"
  agent = 1
  cores = 2
  sockets = "1"
  memory = 2048
  cpu = "host"
  scsihw = "virtio-scsi-pci"
  bootdisk = "virtio0"

disk {
    slot = 0
    size = "10G"
    type = "virtio"
    storage = "vm-system"
}

disk {
    slot = 1
    size = "10G"
    type = "virtio"
    storage = var.storage
}



network {
    model           = "virtio"
    bridge          = "vmbr0"
}

  lifecycle {
    ignore_changes = [
      network,
    ]
  }



# Cloud Init Settings
ipconfig0 = "ip=192.168.56.2${count.index + 1}/24,gw=192.168.56.1"
 ssh_user = "ubuntu" 
 sshkeys = var.ssh_keys


connection {
type = "ssh"  
user = "ubuntu"
private_key = file("~/.ssh/id_rsa")
host = "192.168.56.2${count.index + 1}"
}

provisioner "remote-exec" {

inline = [

"sudo parted -s /dev/vdb mklabel gpt && sudo parted -s /dev/vdb mkpart primary ext4 0% 100%",

"sudo mkfs.ext4 /dev/vdb1",

"sudo mkdir /gluster-storage01",

"sudo echo '/dev/vdb1 /gluster-storage01 ext4 defaults 0 0' >> /etc/fstab",

"sudo mount -a",

"lsblk"

]

}

}



resource "proxmox_vm_qemu" "db_virtual_machine" {
  count = 3
  name = "db${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template
  os_type = "cloud-init"
  agent = 1
  cores = 2
  sockets = "1"
  memory = 2048
  cpu = "host"
  scsihw = "virtio-scsi-pci"
  bootdisk = "virtio0"

disk {
    slot = 0
    size = "10G"
    type = "virtio"
    storage = "vm-system"
}


network {
    model           = "virtio"
    bridge          = "vmbr0"
}

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

# Cloud Init Settings
ipconfig0 = "ip=192.168.56.3${count.index + 1}/24,gw=192.168.56.1"
 ssh_user = "ubuntu" 
 sshkeys = var.ssh_keys



}

resource "proxmox_vm_qemu" "haproxy" {
  count = 2
  name = "haproxy${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template
  os_type = "cloud-init"
  agent = 1
  cores = 2
  sockets = "1"
  memory = 2048
  cpu = "host"
  scsihw = "virtio-scsi-pci"
  bootdisk = "virtio0"

disk {
    slot = 0
    size = "10G"
    type = "virtio"
    storage = var.storage
}


network {
    model           = "virtio"
    bridge          = "vmbr0"
}

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

# Cloud Init Settings
ipconfig0 = "ip=192.168.56.10${count.index + 1}/24,gw=192.168.56.1"
 ssh_user = "ubuntu" 
 sshkeys = var.ssh_keys



}