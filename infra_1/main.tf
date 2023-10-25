terraform {
  required_version = "~> 1.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.54"
    }
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
  default     = ""
  description = "Environment name"
}

variable "workload" {
  type        = string
  default     = ""
  description = "Workload name"
}


resource "azurerm_resource_group" "this" {
  name     = "rg-${var.workload}-${var.environment}"
  location = "westeurope"
}

# Comment