# Terraform 4 NIC Standalone Fortigate Firewall

## Introduction

This Terraform module deploys a 4 NIC standalone Fortigate Firewall.

## Security Controls

The following security controls can be met through configuration of this template:

* AC-1, AC-10, AC-11, AC-11(1), AC-12, AC-14, AC-16, AC-17, AC-18, AC-18(4), AC-2 , AC-2(5), AC-20(1) , AC-20(3), AC-20(4), AC-24(1), AC-24(11), AC-3, AC-3 , AC-3(1), AC-3(3), AC-3(9), AC-4, AC-4(14), AC-6, AC-6, AC-6(1), AC-6(10), AC-6(11), AC-7, AC-8, AC-8, AC-9, AC-9(1), AI-16, AU-2, AU-3, AU-3(1), AU-3(2), AU-4, AU-5, AU-5(3), AU-8(1), AU-9, CM-10, CM-11(2), CM-2(2), CM-2(4), CM-3, CM-3(1), CM-3(6), CM-5(1), CM-6, CM-6, CM-7, CM-7, IA-1, IA-2, IA-3, IA-4(1), IA-4(4), IA-5, IA-5, IA-5(1), IA-5(13), IA-5(1c), IA-5(6), IA-5(7), IA-9, SC-10, SC-13, SC-15, SC-18(4), SC-2, SC-2, SC-23, SC-28, SC-30(5), SC-5, SC-7, SC-7(10), SC-7(16), SC-7(8), SC-8, SC-8(1), SC-8(4), SI-14, SI-2(1), SI-3

## Dependancies

* [Resource Groups](https://github.com/canada-ca-azure-templates/resourcegroups/blob/master/readme.md)
* [Keyvault](https://github.com/canada-ca-azure-templates/keyvaults/blob/master/readme.md)
* [VNET-Subnet](https://github.com/canada-ca-azure-templates/vnet-subnet/blob/master/readme.md)

## Usage

```terraform
terraform {
  required_version = ">= 0.12.1"
}

provider "azurerm" {
  version         = "= 1.31.0"
  subscription_id = "2de839a0-37f9-4163-a32a-e1bdb8d6eb7e"
}

data "azurerm_client_config" "current" {}

variable "envprefix" {
  description = "Prefix for the environment"
  default     = "Demo"
}

module "fortigateap" {
  #source = "github.com/canada-ca-terraform-modules/terraform-azurerm-fortigateap?ref=20190725.1"
  source = "./terraform-azurerm-fortigateap"

  location  = "canadacentral"
  envprefix = "${var.envprefix}"
  
  keyvault = {
    name                = "${var.envprefix}-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${var.envprefix}-Core-Keyvault-RG"),0,8)}"
    resource_group_name = "${var.envprefix}-Core-Keyvault-RG"
  }
  
  firewall = {
    fwprefix = "${var.envprefix}-FW"
    vm_size     = "Standard_F4"
    adminName = "fwadmin"
    secretPasswordName = "fwpassword"
    vnet_name = "${var.envprefix}-Core-NetCore-VNET"
    fortigate_resourcegroup_name = "${var.envprefix}-Core-FWCore-RG"
    keyvault_resourcegroup_name = "${var.envprefix}-Core-Keyvault-RG"
    vnet_resourcegroup_name = "${var.envprefix}-Core-NetCore-RG"
    fwa_custom_data = "fwconfig/coreA-lic.conf"
    fwb_custom_data = "fwconfig/coreB-lic.conf"
    # Associated to Nic1
    subnet1_name = "${var.envprefix}-Outside"
    # Associated to Nic2
    subnet2_name = "${var.envprefix}-CoreToSpokes"
    # Associated to Nic3
    subnet3_name = "${var.envprefix}-Management"
    # Associated to Nic4
    subnet4_name = "${var.envprefix}-HASync"
    # Firewall A NIC Private IPs
    fwa_nic1_private_ip_address = "100.96.112.4"
    fwa_nic2_private_ip_address = "100.96.116.5"
    fwa_nic3_private_ip_address = "100.96.116.36"
    fwa_nic4_private_ip_address = "100.96.116.68"
    # Firewall B NIC Private IPs
    fwb_nic1_private_ip_address = "100.96.112.5"
    fwb_nic2_private_ip_address = "100.96.116.6"
    fwb_nic3_private_ip_address = "100.96.116.37"
    fwb_nic4_private_ip_address = "100.96.116.69"
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
  }
}

resource azurerm_lb_rule FW-ExternalLoadBalancer__jumpboxRDP {
  name                           = "jumpboxRDP"
  resource_group_name            = "${var.envprefix}-Core-FWCore-RG"
  loadbalancer_id                = "${module.fortigateap.loadbalancer_id}"
  frontend_ip_configuration_name = "${var.envprefix}FWpublicLBFE"
  protocol                       = "Tcp"
  frontend_port                  = "33890"
  backend_port                   = "33890"
  backend_address_pool_id        = "${module.fortigateap.backend_address_pool_id}"
  probe_id                       = "${module.fortigateap.probe_id}"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = "15"
  load_distribution              = "Default"
}
```

## Parameter Values

TO BE DOCUMENTED

### Tag variable

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

## History

| Date     | Release    | Change                                                                                                             |
| -------- | ---------- | ------------------------------------------------------------------------------------------------------------------ |
| 20190725 | 20190725.1 | Fix missing backend LB association and add support for lbrules definition using output from module as demonstrated |
| 20190724 | 20190724.1 | 1st deploy                                                                                                         |
