terraform {
  required_version = ">= 0.12.1"
}
provider "azurerm" {
  version = ">= 1.32.0"
  # subscription_id = "2de839a0-37f9-4163-a32a-e1bdb8d6eb7e"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "test-fortigate-RG" {
  name     = "test-fortigate-RG"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "test-VNET" {
  name                = "test-VNET"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.test-fortigate-RG.name}"
  address_space       = ["10.10.10.0/23"]
}
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  virtual_network_name = "${azurerm_virtual_network.test-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.test-fortigate-RG.name}"
  address_prefix       = "10.10.10.0/27"
}
resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  virtual_network_name = "${azurerm_virtual_network.test-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.test-fortigate-RG.name}"
  address_prefix       = "10.10.10.64/27"
}

resource "azurerm_subnet" "subnet3" {
  name                 = "subnet3"
  virtual_network_name = "${azurerm_virtual_network.test-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.test-fortigate-RG.name}"
  address_prefix       = "10.10.10.128/27"
}

resource "azurerm_subnet" "subnet4" {
  name                 = "subnet4"
  virtual_network_name = "${azurerm_virtual_network.test-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.test-fortigate-RG.name}"
  address_prefix       = "10.10.10.192/27"
}

module "test-firewall" {
  source = "../."

  fwprefix                     = "${var.envprefix}-FW"
  vm_size                      = "Standard_F4"
  adminName                    = "fwadmin"
  secretPasswordName           = "${azurerm_key_vault_secret.test1.name}"
  vnet_name                    = "${azurerm_virtual_network.test-VNET.name}"
  fortigate_resourcegroup_name = "${azurerm_resource_group.test-fortigate-RG.name}"
  keyvault_resourcegroup_name  = "${azurerm_resource_group.test-fortigate-RG.name}"
  vnet_resourcegroup_name      = "${azurerm_resource_group.test-fortigate-RG.name}"
  fw_custom_data               = "fwconfig/fwconfig-lic.conf"
  # Associated to Nic1
  subnet1_name = "${azurerm_subnet.subnet1.name}"
  # Associated to Nic2
  subnet2_name = "${azurerm_subnet.subnet2.name}"
  # Associated to Nic3
  subnet3_name = "${azurerm_subnet.subnet3.name}"
  # Associated to Nic4
  subnet4_name = "${azurerm_subnet.subnet4.name}"
  # Firewall A NIC Private IPs
  nic1_private_ip_address = "10.10.10.4"
  nic2_private_ip_address = "10.10.10.68"
  nic3_private_ip_address = "10.10.10.132"
  nic4_private_ip_address = "10.10.10.196"
  storage_image_reference = {
    publisher = "fortinet"
    offer     = "fortinet_fortigate-vm_v5"
    sku       = "fortinet_fg-vm"
    version   = "latest"
  }
  plan = {
    name      = "fortinet_fg-vm"
    publisher = "fortinet"
    product   = "fortinet_fortigate-vm_v5"
  }
  keyvaultName              = "${azurerm_key_vault.test-keyvault.name}"
  keyvaultResourceGroupName = "${azurerm_resource_group.test-fortigate-RG.name}"
  tags                      = "${var.tags}"
}
