# Create a resource group
resource "azurerm_resource_group" "wownero_node_group" {
  name     = "wownero-node-resources"
  location = "eastus"
  tags = {
    environment = "Wownero Node"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "wownero_node_network" {
    name                = "wownero_vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.wownero_node_group.name
    tags = {
        environment = "Wownero Node"
    }
}

# Create subnet
resource "azurerm_subnet" "wownero_node_subnet" {
    name                 = "wownero_subnet"
    resource_group_name  = azurerm_resource_group.wownero_node_group.name
    virtual_network_name = azurerm_virtual_network.wownero_node_network.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "wownero_node_public_ip" {
    name                         = "wownero_public_ip"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.wownero_node_group.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Wownero Node"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "wownero_node_network_security_group" {
    name                = "wownero_networksecuritygroup"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.wownero_node_group.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    tags = {
        environment = "Wownero Node"
    }
}
# Create network interface
resource "azurerm_network_interface" "wownero_node_nic" {
    name                      = "wownero_nic"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.wownero_node_group.name

    ip_configuration {
        name                          = "wownero_nic_config"
        subnet_id                     = azurerm_subnet.wownero_node_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.wownero_node_public_ip.id
    }

    tags = {
        environment = "Wownero Node"
    }
}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "wownero_node_network_security_group" {
    network_interface_id      = azurerm_network_interface.wownero_node_nic.id
    network_security_group_id = azurerm_network_security_group.wownero_node_network_security_group.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.wownero_node_group.name
    }

    byte_length = 8
}
# Create storage account for boot diagnostics
resource "azurerm_storage_account" "wownero_node_storage_account" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.wownero_node_group.name
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Wownero Node"
    }
}
# Create (and display) an SSH key
resource "tls_private_key" "wownero_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" {
    value = tls_private_key.wownero_ssh.private_key_pem
    sensitive = true
}
# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
    name                  = "WowneroNode"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.wownero_node_group.name
    network_interface_ids = [azurerm_network_interface.wownero_nic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "WowneroNodeDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "20.04-LTS"
        version   = "latest"
    }

    computer_name  = "WowneroNode"
    admin_username = "root"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "root"
        public_key     = tls_private_key.wownero_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.wownero_node_storage_account.primary_blob_endpoint
    }

    tags = {
        environment = "Wownero Node"
    }
}
