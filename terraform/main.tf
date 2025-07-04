# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.35.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "<storage_account_name>"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "29990943-5404-4952-b4fb-5c27b2c24948"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "file-upload-resources"
  location = "westeurope"
}

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create an Azure Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "storageaccount${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource azurerm_storage_container "storage_container" {
  name                  = "file-upload-storage-container"
  storage_account_id = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}
