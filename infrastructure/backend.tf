# backend.tf — Remote state Azure Blob
# A compléter après création du storage account
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-sentinel"
    storage_account_name = "stsentinelstate4593"
    container_name       = "tfstate"
    key                  = "sentinel-lab.tfstate"
  }
}