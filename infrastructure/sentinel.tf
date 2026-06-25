# sentinel.tf — Activation Microsoft Sentinel
# A compléter à l'étape Infrastructure
# Activation de Microsoft Sentinel sur le Log Analytics Workspace
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.sentinel.id
}