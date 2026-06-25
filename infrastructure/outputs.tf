# outputs.tf — Exports utiles (workspace ID, etc.)
# A compléter à l'étape Infrastructure
output "resource_group_name" {
  value       = azurerm_resource_group.sentinel_lab.name
  description = "Nom du resource group du lab"
}

output "workspace_id" {
  value       = azurerm_log_analytics_workspace.sentinel.id
  description = "ID complet du Log Analytics Workspace"
}

output "workspace_name" {
  value       = azurerm_log_analytics_workspace.sentinel.name
  description = "Nom du workspace"
}

output "sentinel_id" {
  value       = azurerm_sentinel_log_analytics_workspace_onboarding.sentinel.id
  description = "ID de l'onboarding Sentinel"
}