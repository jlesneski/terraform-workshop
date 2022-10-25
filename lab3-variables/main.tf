terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    resource_group_name         = "terraform"
    storage_account_name        = "terraformlucidia"
    container_name              = "tfstate"
    key                         = "lab3/tfstate"
    subscription_id             = "62b4ac63-dbaf-4233-bb78-63a2a2539745"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "62b4ac63-dbaf-4233-bb78-63a2a2539745"
}

#locals {
#  default_tags = {
#    Source      = "terraform"
#    Project     = "Lab3"
#  }
#  env_tags = {
#    Environment = "DEV"
#    Department  = "HR"
#  }
#}

resource "azurerm_resource_group" "rsg_lab3" {
  name                = "lab3"
  location            = "Central US"
  #tags = merge(local.default_tags, local.env_tags, {
  tags = {
    Name = "lab3"
  }#)
}

resource "azurerm_virtual_network" "lab3_vm_vnet" {
  name                = "lab3-vm-vnet"
  location            = azurerm_resource_group.rsg_lab3.location
  resource_group_name = azurerm_resource_group.rsg_lab3.name
  address_space       = ["10.212.99.0/24"] 
  #tags = merge(local.default_tags, local.env_tags, {
  tags = {
    Name = "lab3-vm-vnet"
  }#)
}

resource "azurerm_subnet" "lab3_vm_subnet" {
  name                 = "lab3-vm-subnet"
  resource_group_name  = azurerm_resource_group.rsg_lab3.name
  virtual_network_name = azurerm_virtual_network.lab3_vm_vnet.name
  address_prefixes     = ["10.212.99.64/27"]
}

resource "azurerm_network_interface" "vm1_lab3_nic1" {
    name                = "vm1-lab3-nic1"
    location            = azurerm_resource_group.rsg_lab3.location
    resource_group_name = azurerm_resource_group.rsg_lab3.name

    ip_configuration {
        name                          = "lab3-vm1-conf-nic1"
        subnet_id                     = azurerm_subnet.lab3_vm_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}




resource "azurerm_virtual_machine" "vm1_lab3" {
  name                  = "vm1-lab3-web1"
  location              = azurerm_resource_group.rsg_lab3.location
  resource_group_name   = azurerm_resource_group.rsg_lab3.name
  network_interface_ids = [azurerm_network_interface.vm1_lab3_nic1.id]
  vm_size               = "Standard_D2_v2"
  delete_os_disk_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "vm1-lab3-web1-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vm1-lab3-web1"
    admin_username = "ubuadmin"
    admin_password = "Passw0rd123456"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  #tags = merge(local.default_tags, local.env_tags, {
  tags = {
    Name = "vm1-lab3-web1"
  }#)
}
