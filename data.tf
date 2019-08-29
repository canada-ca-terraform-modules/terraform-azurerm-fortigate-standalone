data "azurerm_key_vault" "keyvaultsecrets" {
  name = "${var.keyvault.name}"
  resource_group_name = "${var.keyvault.resource_group_name}"
}

data "azurerm_key_vault_secret" "fwpasswordsecret" {
  name         = "${var.secretPasswordName}"
  key_vault_id = "${data.azurerm_key_vault.keyvaultsecrets.id}"
}

data "azurerm_subnet" "subnet1" {
  name                 = "${var.subnet1_name}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.vnet_resourcegroup_name}"
}

data "azurerm_subnet" "subnet2" {
  name                 = "${var.subnet2_name}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.vnet_resourcegroup_name}"
}

data "azurerm_subnet" "subnet3" {
  name                 = "${var.subnet3_name}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.vnet_resourcegroup_name}"
}

data "azurerm_subnet" "subnet4" {
  name                 = "${var.subnet4_name}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.vnet_resourcegroup_name}"
}

