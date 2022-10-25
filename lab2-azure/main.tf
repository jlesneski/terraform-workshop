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
    key                         = "lab2/tfstate"
    subscription_id             = "62b4ac63-dbaf-4233-bb78-63a2a2539745"
  }
}

provider "azurerm" {
  features {}
  #subscription_id = "62b4ac63-dbaf-4233-bb78-63a2a2539745"
}

resource "azurerm_resource_group" "rsg_lab2" {
  name                = "lab2"
  location            = "Central US"
}

resource "azurerm_virtual_network" "lab2_vm_vnet" {
  name                = "lab2-vm-vnet"
  location            = azurerm_resource_group.rsg_lab2.location
  resource_group_name = azurerm_resource_group.rsg_lab2.name
  address_space       = ["10.211.99.0/24"] 
}

resource "azurerm_subnet" "lab2_vm_subnet" {
  name                 = "lab2-vm-subnet"
  resource_group_name  = azurerm_resource_group.rsg_lab2.name
  virtual_network_name = azurerm_virtual_network.lab2_vm_vnet.name
  address_prefixes     = ["10.211.99.64/27"]
}

resource "azurerm_network_interface" "vm1_lab2_nic1" {
    name                = "vm1-lab2-nic1"
    location            = azurerm_resource_group.rsg_lab2.location
    resource_group_name = azurerm_resource_group.rsg_lab2.name

    ip_configuration {
        name                          = "lab2-vm1-conf-nic1"
        subnet_id                     = azurerm_subnet.lab2_vm_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "vm1_lab2" {
    name                  = "vm1-lab2-web1"
    location              = azurerm_resource_group.rsg_lab2.location
    resource_group_name   = azurerm_resource_group.rsg_lab2.name
    network_interface_ids = [azurerm_network_interface.vm1_lab2_nic1.id]
    vm_size               = "Standard_D2_v2"
    delete_os_disk_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm1-lab2-web1-os"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm1-lab2-web1"
        admin_username = "ubuadmin"
        admin_password = "Passw0rd123456"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}
