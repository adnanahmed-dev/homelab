output "vm_ips" {
  description = "The IP addresses of the created K3s nodes"
  value = {
    for k, v in proxmox_virtual_environment_vm.cloud_init_debian_vm : k => v.initialization[0].ip_config[0].ipv4[0].address
  }
}