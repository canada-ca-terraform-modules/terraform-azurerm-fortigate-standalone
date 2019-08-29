variable "location" {
  description = "Location of the network"
  default     = "canadacentral"
}

variable "tags" {
  description = "Tags that will be associated to VM resources"
  default = {
    "exampleTag1" = "SomeValue1"
    "exampleTag1" = "SomeValue2"
  }
}

variable "name" {}
variable "admin_username" {}
variable "secretPasswordName" {}
variable "vnet_name" {}
variable "resourcegroup_name" {}
variable "vnet_resourcegroup_name" {}
variable "custom_data" {}
variable "subnet1_name" {}
variable "subnet2_name" {}
variable "subnet3_name" {}
variable "subnet4_name" {}
variable "nic1_private_ip_address" {}
variable "nic1_public_ip" { default = true }
variable "nic2_private_ip_address" {}
variable "nic3_private_ip_address" {}
variable "nic4_private_ip_address" {}
variable "vm_size" {
  default = "Standard_F4"
}
variable "storage_image_reference" {
  default = {
    publisher = "fortinet"
    offer     = "fortinet_fortigate-vm_v5"
    sku       = "fortinet_fg-vm"
    version   = "latest"
  }
}
variable "plan" {
  default = {
    name      = "fortinet_fg-vm"
    publisher = "fortinet"
    product   = "fortinet_fortigate-vm_v5"
  }
}
variable "keyvault" {
  description = "This block describe the keyvault resource name and resourcegroup name containing the keyvault"
  default = {
    name                = ""
    resource_group_name = ""
  }
}
