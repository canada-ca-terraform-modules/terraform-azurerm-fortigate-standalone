variable "location" {
  description = "Location of the network"
  default     = "canadacentral"
}

variable "envprefix" {
  description = "Prefix for the environment"
  default     = "Demo"
}

variable "tags" {
  default = {
    "Organizations"     = "PwP0-CCC-E&O"
    "DeploymentVersion" = "2018-12-14-01"
    "Classification"    = "Unclassified"
    "Enviroment"        = "Sandbox"
    "CostCenter"        = "PwP0-EA"
    "Owner"             = "cloudteam@tpsgc-pwgsc.gc.ca"
  }
}

variable "keyvaultName" {

}
variable "keyvaultResourceGroupName" {

}

variable "fwprefix" {

}
variable "vm_size" {
  default = "Standard_F4"
}
variable "adminName" {
  
}
variable "secretPasswordName" {
  
}


variable "vnet_name" {}
variable "fortigate_resourcegroup_name" {}
variable "vnet_resourcegroup_name" {}
variable "fw_custom_data" {}
variable "subnet1_name" {}
variable "subnet2_name" {}
variable "subnet3_name" {}
variable "subnet4_name" {}
variable "nic1_private_ip_address" {}
variable "nic2_private_ip_address" {}
variable "nic3_private_ip_address" {}
variable "nic4_private_ip_address" {}
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
