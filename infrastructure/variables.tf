# variables.tf — Déclaration des variables
# A compléter à l'étape Infrastructure
variable "subscription_id" {
  type        = string
  description = "ID de la subscription Azure"
}

variable "location" {
  type        = string
  description = "Région Azure"
  default     = "francecentral"
}

variable "resource_group_name" {
  type        = string
  description = "Nom du resource group principal du lab"
  default     = "rg-sentinel-lab"
}

variable "workspace_name" {
  type        = string
  description = "Nom du Log Analytics Workspace"
  default     = "law-sentinel-lab"
}

variable "retention_days" {
  type        = number
  description = "Rétention des logs en jours"
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags appliqués à toutes les ressources"
  default = {
    env     = "lab"
    project = "azure-sentinel-lab"
    owner   = "ivan"
  }
}