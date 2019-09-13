resource azurerm_network_security_group nsg {
  name                = "${var.name}-nsg"
  location            = "${var.location}"
  resource_group_name = "${var.resourcegroup_name}"
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
  name                          = "${var.name}-Nic1"
  depends_on                    = [var.vm_depends_on]
  location                      = "${var.location}"
  resource_group_name           = "${var.resourcegroup_name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.nsg.id}"
  dynamic "ip_configuration" {
    for_each = var.nic1_private_ip_address
    content {
      name                          = "ipconfig${ip_configuration.key + 1}"
      subnet_id                     = "${data.azurerm_subnet.subnet1.id}"
      private_ip_address            = "${var.nic1_private_ip_address[ip_configuration.key]}"
      private_ip_address_allocation = "Static"
      public_ip_address_id          = var.nic1_public_ip ? azurerm_public_ip.FW-pip[ip_configuration.key].id : null
      primary                       = ip_configuration.key == 0 ? true : false
    }
  }
}

resource azurerm_network_interface FW-Nic2 {
  name                          = "${var.name}-Nic2"
  depends_on                    = [var.vm_depends_on]
  location                      = "${var.location}"
  resource_group_name           = "${var.resourcegroup_name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.nsg.id}"
  dynamic "ip_configuration" {
    for_each = var.nic2_private_ip_address
    content {
      name                          = "ipconfig${ip_configuration.key + 1}"
      subnet_id                     = "${data.azurerm_subnet.subnet2.id}"
      private_ip_address            = "${var.nic2_private_ip_address[ip_configuration.key]}"
      private_ip_address_allocation = "Static"
      primary                       = ip_configuration.key == 0 ? true : false
    }
  }
}

resource azurerm_network_interface FW-Nic3 {
  name                          = "${var.name}-Nic3"
  depends_on                    = [var.vm_depends_on]
  location                      = "${var.location}"
  resource_group_name           = "${var.resourcegroup_name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.nsg.id}"
  dynamic "ip_configuration" {
    for_each = var.nic3_private_ip_address
    content {
      name                          = "ipconfig${ip_configuration.key + 1}"
      subnet_id                     = "${data.azurerm_subnet.subnet3.id}"
      private_ip_address            = "${var.nic3_private_ip_address[ip_configuration.key]}"
      private_ip_address_allocation = "Static"
      primary                       = ip_configuration.key == 0 ? true : false
    }
  }
}

resource azurerm_network_interface FW-Nic4 {
  name                          = "${var.name}-Nic4"
  depends_on                    = [var.vm_depends_on]
  location                      = "${var.location}"
  resource_group_name           = "${var.resourcegroup_name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.nsg.id}"
  dynamic "ip_configuration" {
    for_each = var.nic4_private_ip_address
    content {
      name                          = "ipconfig${ip_configuration.key + 1}"
      subnet_id                     = "${data.azurerm_subnet.subnet4.id}"
      private_ip_address            = "${var.nic4_private_ip_address[ip_configuration.key]}"
      private_ip_address_allocation = "Static"
      primary                       = ip_configuration.key == 0 ? true : false
    }
  }
}

# If public_ip is true then create resource. If not then do not create any
resource azurerm_public_ip FW-pip {
  count               = var.nic1_public_ip ? length(var.nic1_private_ip_address) : 0
  name                = "${var.name}-pip${count.index + 1}"
  location            = "${var.location}"
  resource_group_name = "${var.resourcegroup_name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_virtual_machine FW {
  name                = "${var.name}-vm"
  location            = "${var.location}"
  resource_group_name = "${var.resourcegroup_name}"
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
    computer_name  = "${var.name}"
    admin_username = "${var.admin_username}"
    admin_password = "${data.azurerm_key_vault_secret.fwpasswordsecret.value}"
    custom_data    = "${file("${var.custom_data}")}"
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
    name          = "${var.name}-osdisk1"
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = "Linux"
    disk_size_gb  = "2"
  }
  storage_data_disk {
    name          = "${var.name}-datadisk1"
    lun           = 0
    caching       = "None"
    create_option = "Empty"
    disk_size_gb  = "30"
  }
  tags = "${var.tags}"
}
