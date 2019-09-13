# Terraform 4 NIC Standalone Fortigate Firewall

## Introduction

This Terraform module deploys a 4 NIC standalone Fortigate Firewall.

## Security Controls

The following security controls can be met through configuration of this template:

* AC-1, AC-10, AC-11, AC-11(1), AC-12, AC-14, AC-16, AC-17, AC-18, AC-18(4), AC-2 , AC-2(5), AC-20(1) , AC-20(3), AC-20(4), AC-24(1), AC-24(11), AC-3, AC-3 , AC-3(1), AC-3(3), AC-3(9), AC-4, AC-4(14), AC-6, AC-6, AC-6(1), AC-6(10), AC-6(11), AC-7, AC-8, AC-8, AC-9, AC-9(1), AI-16, AU-2, AU-3, AU-3(1), AU-3(2), AU-4, AU-5, AU-5(3), AU-8(1), AU-9, CM-10, CM-11(2), CM-2(2), CM-2(4), CM-3, CM-3(1), CM-3(6), CM-5(1), CM-6, CM-6, CM-7, CM-7, IA-1, IA-2, IA-3, IA-4(1), IA-4(4), IA-5, IA-5, IA-5(1), IA-5(13), IA-5(1c), IA-5(6), IA-5(7), IA-9, SC-10, SC-13, SC-15, SC-18(4), SC-2, SC-2, SC-23, SC-28, SC-30(5), SC-5, SC-7, SC-7(10), SC-7(16), SC-7(8), SC-8, SC-8(1), SC-8(4), SI-14, SI-2(1), SI-3

## Dependancies

* Resource Groups
* Keyvault
* VNET-Subnet

## Usage

```terraform
module "fortigateap" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-fortigate-standalone-4nic?ref=20190829.1"

  name                         = "Something-FW"
  resourcegroup_name           = "someRGName"
  vm_size                      = "Standard_F4"
  admin_username               = "fwadmin"
  secretPasswordName           = "someSecretPasswordName"
  custom_data                  = "fwconfig/fwconfig-lic.conf"
  vnet_name                    = "someVnetName"
  vnet_resourcegroup_name      = "someVnetName"
  subnet1_name                 = "someName"
  subnet2_name                 = "someName"
  subnet3_name                 = "someName"
  subnet4_name                 = "someName"
  nic1_private_ip_address      = ["10.10.10.6", "10.10.10.7"]
  nic1_public_ip               = false
  nic2_private_ip_address      = ["10.10.10.69", "10.10.10.70"]
  nic3_private_ip_address      = ["10.10.10.134", "10.10.10.135"]
  nic4_private_ip_address      = ["10.10.10.197"]
  keyvault = {
    name                 = "somekeyvault.name"
    resource_group_name  = "someKVRGName"
  }
  tags                         = "someTags"
}
```

## Variables Values

| Name                    | Type   | Required | Value                                                                                                                                 |
| ----------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| name                    | string | yes      | Name for the firewall resource                                                                                                        |
| resource_group_name     | string | yes      | Name of the resourcegroup that will contain the Firewall resources                                                                    |
| admin_username          | string | yes      | Name of the VM admin account                                                                                                          |
| secretPasswordName      | string | yes      | Name of the Keyvault secret containing the VM admin account password                                                                  |
| custom_data             | string | yes      | some base firewall config code to apply. Eg: "fwconfig/fwconfig-lic.conf"                                                             |
| vnetName                | string | yes      | Name of the VNET the subnet is part of                                                                                                |
| vnet_resourcegroup_name | string | yes      | Name of the resourcegroup containing the VNET                                                                                         |
| subnet1Name             | string | yes      | Name of the subnet where NIC1 will connect to                                                                                         |
| subnet2Name             | string | yes      | Name of the subnet where NIC2 will connect to                                                                                         |
| subnet3Name             | string | yes      | Name of the subnet where NIC3 will connect to                                                                                         |
| subnet4Name             | string | yes      | Name of the subnet where NIC4 will connect to                                                                                         |
| keyvault                | object | yes      | Object containing keyvault resource configuration. - [keyvault](#keyvault-object)                                                     |
| tags                    | object | yes      | Object containing a tag values - [tags pairs](#tag-object)                                                                            |
| nic1_private_ip_address | list   | yes      | List of private IP for the NIC1 - Eg: for two IP: ["10.10.10.10", "10.10.10.11"]                                                      |
| nic2_private_ip_address | list   | yes      | List of private IP for the NIC2 - Eg: for one IP: ["10.10.20.10"]                                                                     |
| nic3_private_ip_address | list   | yes      | List of private IP for the NIC3 - Eg: for one IP: ["10.10.30.10"]                                                                     |
| nic4_private_ip_address | list   | yes      | List of private IP for the NIC4 - Eg: for one IP: ["10.10.40.10"]                                                                     |
| storage_image_reference | object | no       | Specify the storage image used to create the VM. Default is 2016-Datacenter. - [storage image](#storage-image-reference-object)       |
| plan                    | object | no       | Specify the plan used to create the VM. - [plan](#plan-object)                                                                        |
| custom_data             | string | no       | some custom ps1 code to execute. Eg: ${file("serverconfig/jumpbox-init.ps1")}                                                         |
| nic1_public_ip          | bool   | no       | Does the Firewall require public IP(s). true or false. Default: true                                                                  |
| location                | string | no       | Azure location for resources. Default: canadacentral                                                                                  |
| vm_size                 | string | no       | Specifies the desired size of the Virtual Machine. Default: Standard_F4                                                               |
| vm_depends_on           | list   | no       | List of [terraform dependancies](#dependancies-list) that need to be deployed before the firewall deployment can start. Default: null |

### tag object

Example tag variable:

```hcl
tags = {
  "tag1name" = "somevalue"
  "tag2name" = "someothervalue"
  .
  .
  .
  "tagXname" = "some other value"
}
```

### storage image reference object

| Name      | Type       | Required           | Value                                                                                              |
| --------- | ---------- | ------------------ | -------------------------------------------------------------------------------------------------- |
| publisher | string     | yes                | The image publisher.                                                                               |
| offer     | string     | yes                | Specifies the offer of the platform image or marketplace image used to create the virtual machine. |
| sku       | string     | yes                | The image SKU.                                                                                     |
| version   | string yes | The image version. |

Example variable:

```hcl
storage_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2016-Datacenter"
  version   = "latest"
}
```

### plan object

| Name      | Type   | Required | Value                                                                                              |
| --------- | ------ | -------- | -------------------------------------------------------------------------------------------------- |
| name      | string | yes      | The image SKU.                                                                                     |
| publisher | string | yes      | The image publisher.                                                                               |
| product   | string | yes      | Specifies the offer of the platform image or marketplace image used to create the virtual machine. |

Example variable:

```hcl
plan = {
  name      = "fortinet_fg-vm"
  publisher = "fortinet"
  product   = "fortinet_fortigate-vm_v5"
}
```

### keyvault object

| Name                | Type   | Required | Value                                                    |
| ------------------- | ------ | -------- | -------------------------------------------------------- |
| name                | string | yes      | Name of the keyvault resource                            |
| resource_group_name | string | yes      | Name of the resource group where the keyvault is located |

Example variable:

```hcl
keyvault = {
  name                = "some-keyvault-name"
  resource_group_name = "some-resource-group-name"
}
```

### dependancies list

| Name     | Type   | Required | Value                                    |
| -------- | ------ | -------- | ---------------------------------------- |
| resource | string | yes      | A resource that has to have been created |
| ...      | ...    | ...      | ...d                                     |
| resource | string | yes      | A resource that has to have been created |

Example variable:

```hcl
vm_depends_on = ["${module.FWCore01.firewall}", "${module.FWMGMT01.firewall}", "${azurerm_public_ip.pip}"]
```

## History

| Date     | Release    | Change                                                                    |
| -------- | ---------- | ------------------------------------------------------------------------- |
| 20190913 | 20190913.1 | Add support for optional vm_depends_on                                    |
| 20190912 | 20190912.1 | Update resource naming to align with proposed GC Cloud naming standard    |
| 20190829 | 20190829.1 | Add support for multiple IP per NIC                                       |
|          |            | Renamed some of the variables to align better with basicvm modules syntax |
|          |            | Update documentation                                                      |
| 20190806 | 20190806.1 | Adding support for optional public IP on NIC 1                            |
| 20190805 | 20190805.1 | 1st deploy                                                                |
