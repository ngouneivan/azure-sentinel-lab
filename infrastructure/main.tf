# main.tf — Resource Group + Log Analytics Workspace
# A compléter à l'étape Infrastructure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Resource group principal du lab
resource "azurerm_resource_group" "sentinel_lab" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Log Analytics Workspace — moteur de stockage et de requête KQL
resource "azurerm_log_analytics_workspace" "sentinel" {
  name                = var.workspace_name
  location            = azurerm_resource_group.sentinel_lab.location
  resource_group_name = azurerm_resource_group.sentinel_lab.name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  tags                = var.tags
}