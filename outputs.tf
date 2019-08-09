output "firewall" {
  value = "${azurerm_virtual_machine.FW}"
}

output "publicIP" {
  value = "${azurerm_public_ip.FW-EXT-PubIP}"
}
