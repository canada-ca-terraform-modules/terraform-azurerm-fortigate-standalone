resource azurerm_network_security_group NSG {
  name                = "${var.fwprefix}-NSG"
  location            = "${var.location}"
  resource_group_name = "${var.fortigate_resourcegroup_name}"
  security_rule {
    name                       = "AllowAllInbound"
    description                = "Allow all in"
    access                     = "Allow"
    priority                   = "100"
    protocol                   = "*"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowAllOutbound"
    description                = "Allow all out"
    access                     = "Allow"
    priority                   = "105"
    protocol                   = "*"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  tags = "${var.tags}"
}

resource azurerm_network_interface FW-Nic1 {
  name                          = "${var.fwprefix}-Nic1"
  location                      = "${var.location}"
  resource_group_name           = "${var.fortigate_resourcegroup_name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = "${data.azurerm_subnet.subnet1.id}"
    private_ip_address                      = "${var.nic1_private_ip_address}"
    private_ip_address_allocation           = "Static"
    public_ip_address_id                    = "${azurerm_public_ip.FW-EXT-PubIP.id}"
    primary                                 = true
  }
}

resource azurerm_network_interface FW-Nic2 {
  name                          = "${var.fwprefix}-Nic2"
  location                      = "${var.location}"
  resource_group_name           = "${var.fortigate_resourcegroup_name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = "${data.azurerm_subnet.subnet2.id}"
    private_ip_address                      = "${var.nic2_private_ip_address}"
    private_ip_address_allocation           = "Static"
    primary                                 = true
  }
}

resource azurerm_network_interface FW-Nic3 {
  name                          = "${var.fwprefix}-Nic3"
  location                      = "${var.location}"
  resource_group_name           = "${var.fortigate_resourcegroup_name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.subnet3.id}"
    private_ip_address            = "${var.nic3_private_ip_address}"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface FW-Nic4 {
  name                          = "${var.fwprefix}-Nic4"
  location                      = "${var.location}"
  resource_group_name           = "${var.fortigate_resourcegroup_name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.subnet4.id}"
    private_ip_address            = "${var.nic4_private_ip_address}"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_public_ip FW-EXT-PubIP {
  name                = "${var.fwprefix}-EXT-PubIP"
  location            = "${var.location}"
  resource_group_name = "${var.fortigate_resourcegroup_name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_virtual_machine FW {
  name                = "${var.fwprefix}"
  location            = "${var.location}"
  resource_group_name = "${var.fortigate_resourcegroup_name}"
  vm_size             = "${var.vm_size}"
  network_interface_ids = [
    "${azurerm_network_interface.FW-Nic1.id}",
    "${azurerm_network_interface.FW-Nic2.id}",
    "${azurerm_network_interface.FW-Nic3.id}",
  "${azurerm_network_interface.FW-Nic4.id}"]
  primary_network_interface_id     = "${azurerm_network_interface.FW-Nic1.id}"
  delete_data_disks_on_termination = "true"
  delete_os_disk_on_termination    = "true"
  os_profile {
    computer_name  = "${var.fwprefix}"
    admin_username = "${var.adminName}"
    admin_password = "${data.azurerm_key_vault_secret.fwpasswordsecret.value}"
    custom_data    = "${file("${var.fw_custom_data}")}"
  }
  storage_image_reference {
    publisher = "${var.storage_image_reference.publisher}"
    offer     = "${var.storage_image_reference.offer}"
    sku       = "${var.storage_image_reference.sku}"
    version   = "${var.storage_image_reference.version}"
  }
  plan {
    name      = "${var.plan.name}"
    publisher = "${var.plan.publisher}"
    product   = "${var.plan.product}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  storage_os_disk {
    name          = "${var.fwprefix}-A_OsDisk_1"
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = "Linux"
    disk_size_gb  = "2"
  }
  storage_data_disk {
    name          = "${var.fwprefix}-A_DataDisk_1"
    lun           = 0
    caching       = "None"
    create_option = "Empty"
    disk_size_gb  = "30"
  }
  tags = "${var.tags}"
}