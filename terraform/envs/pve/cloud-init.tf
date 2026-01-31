resource "proxmox_virtual_environment_vm" "cloud_init_debian_vm" {
  for_each = var.vm_configs

  node_name = each.value.node
  vm_id     = each.value.vm_id
  name        = each.value.name
  description = "Managed by Terraform"
  tags        = ["terraform", each.value.tag]
  on_boot     = each.value.onboot
  started     = each.value.started

	clone {
		vm_id = 1000  # ID of the template VM to clone from
		full = true
	}

	operating_system {
  	type = "l26" # This represents Linux 2.6+ kernel (standard for modern Linux)
	}

  cpu {
    type         = "x86-64-v2-AES"  # recommended for modern CPUs
    cores        = each.value.cores
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory # set equal to dedicated to enable ballooning
  }

	# DISK CONFIGURATION
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    ssd          = true
    size         = each.value.disk_size # Resizes the 10GB template to 20GB
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
		timeout = "2m"
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true

  startup {
    order      = each.value.startup_order
    up_delay   = each.value.startup_delay_up
    down_delay = each.value.startup_delay_down
  }

	initialization {
    datastore_id = "local-lvm" # Where to store the cloud-init ISO
    
    user_account {
      username = each.value.ci_username
      password = var.ci_password
      keys     = [var.ssh_public_key]
    }

    ip_config {
      ipv4 {
        address = each.value.ip_address
        gateway = each.value.gateway
      }
    }
  }

	network_device {
    bridge = each.value.bridge
    vlan_id = each.value.vlan_tag == null ? null : each.value.vlan_tag # Example: if you want to use the network_tag as a VLAN ID, map it here
    firewall = true
  }

	vga {
    type = "serial0"
  }

	serial_device {} # Adds the socket
}
