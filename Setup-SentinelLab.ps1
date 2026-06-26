# Setup-SentinelLab.ps1
# Crée toute la structure du projet Sentinel depuis la racine du dossier

$root = "D:\personnel-ivan\PROJETS-PERSO-LAB\Azure Sentinel (Microsoft Defender XDR + SIEM)"

# Définition de tous les dossiers à créer
$folders = @(
    "infrastructure",
    "sentinel-config\connectors",
    "sentinel-config\analytics-rules",
    "kql-queries",
    "playbooks",
    "scripts",
    "docs\screenshots"
)

# Définition de tous les fichiers à créer avec leur contenu initial
$files = @{
    "README.md"                                              = "# Azure Sentinel Lab`n`n## Objectif`nDéploiement d'un SIEM cloud-native sur Azure avec Microsoft Sentinel, règles KQL custom, connecteurs de logs et playbooks Logic App.`n`n## Stack technique`n- Microsoft Sentinel (SIEM)`n- Log Analytics Workspace`n- KQL (Kusto Query Language)`n- Terraform (IaC)`n- Logic Apps (SOAR / playbooks)`n- Azure Arc (logs on-prem)`n`n## Structure du projet`nVoir `docs/architecture.md``n`n## Auteur`nIvan — Master MICSI — Alternant SCP`n"
    ".gitignore"                                             = "# Terraform`n*.tfstate`n*.tfstate.backup`n*.tfvars`n.terraform/`n.terraform.lock.hcl`nterraform.tfplan`n`n# Secrets et credentials`n*.json.secret`ncredentials.json`n.env`n`n# VS Code`n.vscode/`n`n# OS`nThumbs.db`n.DS_Store`n"
    "lab-config.json"                                        = "{`n  `"project`": `"azure-sentinel-lab`",`n  `"location`": `"francecentral`",`n  `"resource_group`": `"rg-sentinel-lab`",`n  `"workspace_name`": `"law-sentinel-lab`",`n  `"tags`": {`n    `"env`": `"lab`",`n    `"project`": `"sentinel-lab`",`n    `"owner`": `"ivan`"`n  }`n}`n"
    "infrastructure\main.tf"                                 = "# main.tf — Resource Group + Log Analytics Workspace`n# A compléter à l'étape Infrastructure`n"
    "infrastructure\sentinel.tf"                             = "# sentinel.tf — Activation Microsoft Sentinel`n# A compléter à l'étape Infrastructure`n"
    "infrastructure\variables.tf"                            = "# variables.tf — Déclaration des variables`n# A compléter à l'étape Infrastructure`n"
    "infrastructure\terraform.tfvars"                        = "# terraform.tfvars — NE PAS COMMITTER DANS GIT`n# A compléter avec tes valeurs réelles`nsubscription_id = `"`"`nadmin_username  = `"`"`nadmin_password  = `"`"`n"
    "infrastructure\outputs.tf"                              = "# outputs.tf — Exports utiles (workspace ID, etc.)`n# A compléter à l'étape Infrastructure`n"
    "infrastructure\backend.tf"                              = "# backend.tf — Remote state Azure Blob`n# A compléter après création du storage account`n"
    "sentinel-config\connectors\windows-security-events.json" = "{`n  `"connector`": `"WindowsSecurityEvents`",`n  `"status`": `"pending`",`n  `"notes`": `"Configurer via DCR dans le portail Sentinel`"`n}`n"
    "sentinel-config\connectors\entra-id-connector.json"    = "{`n  `"connector`": `"AzureActiveDirectory`",`n  `"status`": `"pending`",`n  `"tables`": [`"SigninLogs`", `"AuditLogs`", `"AADNonInteractiveUserSignInLogs`"]`n}`n"
    "sentinel-config\analytics-rules\brute-force-rdp.json"  = "{`n  `"name`": `"Brute Force RDP Détectée`",`n  `"severity`": `"High`",`n  `"tactic`": `"CredentialAccess`",`n  `"technique`": `"T1110`",`n  `"status`": `"pending`"`n}`n"
    "sentinel-config\analytics-rules\suspicious-signin.json" = "{`n  `"name`": `"Connexion suspecte hors pays`",`n  `"severity`": `"Medium`",`n  `"tactic`": `"InitialAccess`",`n  `"status`": `"pending`"`n}`n"
    "sentinel-config\analytics-rules\account-creation.json" = "{`n  `"name`": `"Création compte inattendue`",`n  `"severity`": `"Medium`",`n  `"tactic`": `"Persistence`",`n  `"status`": `"pending`"`n}`n"
    "kql-queries\detection-brute-force.kql"                  = "// Détection brute force RDP — EventID 4625`n// A remplir à l'étape KQL`n"
    "kql-queries\detection-suspicious-signin.kql"            = "// Connexion suspecte Entra ID — SigninLogs`n// A remplir à l'étape KQL`n"
    "kql-queries\detection-account-creation.kql"             = "// Création de compte — EventID 4720`n// A remplir à l'étape KQL`n"
    "kql-queries\detection-privilege-escalation.kql"         = "// Élévation de privilèges — EventID 4672`n// A remplir à l'étape KQL`n"
    "kql-queries\hunting-global-activity.kql"                = "// Tableau de bord activité Security 24h`n// A remplir à l'étape KQL`n"
    "playbooks\notify-on-incident.json"                      = "{`n  `"playbook`": `"notify-on-incident`",`n  `"trigger`": `"Microsoft Sentinel incident`",`n  `"status`": `"pending`"`n}`n"
    "playbooks\playbook-deploy.ps1"                          = "# playbook-deploy.ps1`n# Déploiement du playbook Logic App via Azure CLI`n# A compléter à l'étape Playbooks`n"
    "scripts\Simulate-BruteForce.ps1"                        = "# Simulate-BruteForce.ps1`n# Simule 15 tentatives de connexion échouées pour déclencher une alerte Sentinel`n# A compléter à l'étape Tests`n"
    "scripts\Simulate-AccountCreation.ps1"                   = "# Simulate-AccountCreation.ps1`n# Crée et supprime un compte test pour générer EventID 4720`n# A compléter à l'étape Tests`n"
    "scripts\Check-DataIngestion.ps1"                        = "# Check-DataIngestion.ps1`n# Vérifie que les tables SecurityEvent et SigninLogs ont des données récentes`n# A compléter à l'étape Connecteurs`n"
    "scripts\Cleanup-Lab.ps1"                                = "# Cleanup-Lab.ps1`n# Supprime toutes les ressources Azure du lab pour économiser les crédits`n# A compléter en fin de lab`n"
    "docs\architecture.md"                                   = "# Architecture du lab`n`n## Schéma`n`nSources → Log Analytics Workspace → Microsoft Sentinel → Incidents → Logic App`n`n## Composants`n- **Log Analytics Workspace** : law-sentinel-lab`n- **Microsoft Sentinel** : SIEM activé sur le workspace`n- **Connecteurs** : Windows Security Events, Entra ID, Azure Arc`n- **Règles KQL** : Brute Force RDP, Connexion suspecte, Création compte`n- **Playbook** : Notification email sur incident High`n"
    "docs\lab-journal.md"                                    = "# Journal de lab — Azure Sentinel`n`n## Progression`n`n| Étape | Statut | Date | Notes |`n|-------|--------|------|-------|`n| Infrastructure Terraform | En attente | - | - |`n| Data connectors | En attente | - | - |`n| Requêtes KQL | En attente | - | - |`n| Analytics rules | En attente | - | - |`n| Playbook Logic App | En attente | - | - |`n| Tests et screenshots | En attente | - | - |`n"
    "docs\linkedin-post-draft.md"                            = "# Brouillon post LinkedIn`n`n## Idée de titre`nDéploiement d'un SIEM cloud-native Azure Sentinel — détection automatique d'incidents + réponse Logic App`n`n## Corps du post`n[A rédiger après les screenshots]`n`n## Keywords à mentionner`nMicrosoft Sentinel, KQL, SIEM, SOC, Logic App, Azure Arc, Entra ID, Brute Force detection, MITRE ATT&CK`n"
}

Write-Host "`n=== Création de la structure du projet Sentinel ===" -ForegroundColor Cyan
Write-Host "Racine : $root`n" -ForegroundColor Gray

# Créer les dossiers
foreach ($folder in $folders) {
    $path = Join-Path $root $folder
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "  [+] Dossier : $folder" -ForegroundColor Green
    } else {
        Write-Host "  [=] Existe déjà : $folder" -ForegroundColor Yellow
    }
}

Write-Host ""

# Créer les fichiers
foreach ($entry in $files.GetEnumerator()) {
    $path = Join-Path $root $entry.Key
    if (-not (Test-Path $path)) {
        $entry.Value | Out-File -FilePath $path -Encoding UTF8 -NoNewline
        Write-Host "  [+] Fichier : $($entry.Key)" -ForegroundColor Green
    } else {
        Write-Host "  [=] Existe déjà : $($entry.Key)" -ForegroundColor Yellow
    }
}

Write-Host "`n=== Structure créée avec succès ===" -ForegroundColor Cyan
Write-Host "`nProchain pas : ouvrir le dossier dans VS Code" -ForegroundColor White
Write-Host "  code `"$root`"" -ForegroundColor Gray