terraform {
  required_version = "~> 1.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.54"
    }
  }
}

terraform {
  backend "azurerm" {
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

variable "subscription_id" {
  type        = string
  default     = ""
  description = "Subscription ID"
}

variable "environment" {
  type        = string
  default     = "all"
  description = "Environment name"
}

variable "workload" {
  type        = string
  default     = "backend"
  description = "Workload name"
}


resource "azurerm_resource_group" "this" {
  name     = "rg-${var.workload}-${var.environment}"
  location = "westeurope"
}

resource "random_string" "this" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}

resource "azurerm_storage_account" "this" {
  name                          = substr("st${var.workload}${var.environment}${random_string.this.result}",0,24)
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
}

resource "azurerm_storage_container" "this" {
  name                  = substr("blob-${var.workload}-${var.environment}",0,63)
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}