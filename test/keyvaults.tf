resource "azurerm_key_vault" "test-keyvault" {
  name                            = "test-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${azurerm_resource_group.test-fortigate-RG.name}"), 0, 8)}"
  location                        = "${var.location}"
  resource_group_name             = "${azurerm_resource_group.test-fortigate-RG.name}"
  sku_name                        = "standard"
  tenant_id                       = "${data.azurerm_client_config.current.tenant_id}"
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
}


resource "azurerm_key_vault_access_policy" "service_principal" {
  key_vault_id = "${azurerm_key_vault.test-keyvault.id}"

  tenant_id = "${data.azurerm_client_config.current.tenant_id}"
  object_id = "${data.azurerm_client_config.current.service_principal_object_id}"
  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
  ]
  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
  ]
  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "ManageContacts",
    "ManageIssuers",
    "GetIssuers",
    "ListIssuers",
    "SetIssuers",
    "DeleteIssuers",
  ]
}

resource "azurerm_key_vault_secret" "test1" {
  name         = "server2016DefaultPassword"
  value        = "Canada123!"
  key_vault_id = "${azurerm_key_vault.test-keyvault.id}"
  depends_on   = ["azurerm_key_vault_access_policy.service_principal"]
}
