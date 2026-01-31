variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "ci_password" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for the cloud-init user"
}

variable "vm_configs" {
  type = map(object({
    node = string
    vm_id = number
    name = string
    cores = number
    memory = number
    disk_size = number
    started = bool
    onboot = bool
    startup_order = string
    startup_delay_up = string
    startup_delay_down = string
    bridge = string
    ip_address = string
    gateway = string
    vlan_tag = number
    ci_username = string
    tag = string
  }))
  default = {
    "test-1" = { node = "pve", vm_id = 100, name = "test-1", cores = 2, memory = 2048, disk_size = 20, started = false, onboot = false, startup_order = "1", startup_delay_up = "0", startup_delay_down="0", bridge = "vmbr0", ip_address = "dhcp", gateway = "192.168.18.1", vlan_tag = null, ci_username = "test", tag = "test" }
  }
}