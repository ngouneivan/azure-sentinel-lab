# 🛡️ Azure Sentinel Lab — SIEM Hybride & SOAR

> Déploiement d'un SIEM cloud-native complet avec Microsoft Sentinel : collecte de logs hybride (Active Directory on-premises via Azure Arc), détection par règles KQL, automatisation des incidents et réponse automatisée (SOAR) — le tout largement déployé en Infrastructure as Code.

![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Cloud-Microsoft_Azure-0078D4?logo=microsoftazure&logoColor=white)
![Sentinel](https://img.shields.io/badge/SIEM-Microsoft_Sentinel-0078D4)
![KQL](https://img.shields.io/badge/Query-KQL-512BD4)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## 📋 Vue d'ensemble

Ce projet met en œuvre un Security Operations Center (SOC) miniature mais fonctionnel, reproduisant l'architecture d'un environnement de production. Un contrôleur de domaine Active Directory hébergé on-premises (VMware) est raccordé au cloud Azure via Azure Arc, ses journaux de sécurité sont ingérés dans Microsoft Sentinel, analysés par des règles de détection personnalisées, et chaque incident déclenche automatiquement une notification à l'équipe SOC.

**Chaîne de détection et de réponse de bout en bout :**

```
Active Directory on-prem (DC-01)
        │  Azure Arc + Azure Monitor Agent
        ▼
Data Collection Rule (Microsoft-SecurityEvent)
        ▼
Log Analytics Workspace  ──►  Microsoft Sentinel
        ▼
Règles analytiques KQL (toutes les 5 min)
        ▼
🚨 Incident automatique (mapping d'entités, MITRE ATT&CK)
        ▼
Règle d'automatisation ──► Playbook Logic App (SOAR)
        ▼
📧 Notification email à l'équipe SOC
```

---

## 🏗️ Architecture

| Composant | Détail |
|-----------|--------|
| **SIEM** | Microsoft Sentinel sur Log Analytics Workspace |
| **Source de logs** | Contrôleur de domaine Windows Server (AD DS) on-premises sur VMware |
| **Connectivité hybride** | Azure Arc (projection de la machine on-prem comme ressource Azure) |
| **Collecte** | Azure Monitor Agent (AMA) + Data Collection Rule stream `Microsoft-SecurityEvent` |
| **Détection** | Règles analytiques planifiées en KQL, mappées sur MITRE ATT&CK |
| **Réponse (SOAR)** | Playbook Logic App + règle d'automatisation |
| **Visualisation** | Workbook / classeur Sentinel (dashboard SOC) |
| **IaC** | Terraform (workspace, Sentinel, DCR, workbook) + Azure CLI |

---

## 🔧 Stack technique

- **Microsoft Sentinel** — SIEM cloud-native
- **Azure Arc** — gestion hybride / connexion de serveurs on-premises
- **Azure Monitor Agent (AMA)** + **Data Collection Rules**
- **KQL (Kusto Query Language)** — requêtes de détection et hunting
- **Azure Logic Apps** — orchestration et réponse automatisée (SOAR)
- **Terraform** — Infrastructure as Code (remote state sur Azure Blob)
- **Azure CLI / PowerShell** — déploiement et automatisation
- **Git / GitHub** — versionnement

---

## 📂 Structure du projet

```
azure-sentinel-lab/
├── infrastructure/              # Terraform (IaC)
│   ├── main.tf                  # Resource group + Log Analytics Workspace
│   ├── sentinel.tf              # Activation Microsoft Sentinel
│   ├── workbook.tf              # Dashboard SOC
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.tf               # Remote state (Azure Blob)
│   └── dcr-securityevent.json   # Définition de la Data Collection Rule
├── kql-queries/                 # Requêtes de détection KQL
│   ├── detection-brute-force.kql
│   ├── detection-privilege-escalation.kql
│   ├── detection-account-creation.kql
│   └── hunting-global-activity.kql
├── sentinel-config/             # Configuration Sentinel
│   ├── connectors/              # Connecteurs de données
│   └── analytics-rules/         # Règles analytiques (JSON)
├── playbooks/                   # SOAR
│   ├── workflow-definition.json # Définition du playbook Logic App
│   └── automation-rule.json     # Règle d'automatisation
├── docs/                        # Documentation et captures
└── scripts/                     # Scripts utilitaires PowerShell
```

---

## 🎯 Détections implémentées

| Détection | EventID | Tactique MITRE | Technique |
|-----------|---------|----------------|-----------|
| **Brute Force** | 4625 | Credential Access | T1110 |
| **Élévation de privilèges** | 4672 | Privilege Escalation | T1078 |
| **Création de compte suspecte** | 4720 | Persistence | T1136 |
| **Threat Hunting global** | multiple | — | Monitoring |

Exemple — détection de brute force (rafale d'échecs de connexion) :

```kql
SecurityEvent
| where EventID == 4625
| summarize NombreEchecs = count(), ComptesVises = make_set(TargetUserName)
    by Computer, IpAddress, bin(TimeGenerated, 10m)
| where NombreEchecs >= 3
```

La règle analytique correspondante s'exécute toutes les 5 minutes, mappe les entités **Host** et **IP** (pour l'investigation graph), et génère automatiquement un incident classé **Credential Access / T1110**.

---

## ⚙️ Reproduire le lab

### Prérequis
- Un abonnement Azure (crédits d'essai suffisants)
- Une VM Windows Server avec le rôle AD DS (testé sur VMware Workstation)
- Terraform, Azure CLI

### Déploiement de l'infrastructure

```bash
# Initialiser le remote state (à adapter)
az group create --name rg-tfstate-sentinel --location francecentral
az storage account create --name <unique> --resource-group rg-tfstate-sentinel --sku Standard_LRS
az storage container create --name tfstate --account-name <unique> --auth-mode login

# Déployer
cd infrastructure
terraform init
terraform plan
terraform apply
```

### Connexion de l'AD on-premises
La machine on-prem est raccordée via Azure Arc (script d'onboarding généré depuis le portail), puis l'Azure Monitor Agent est déployé automatiquement par la Data Collection Rule.

---

## 📊 Points clés / Compétences démontrées

- Conception et déploiement d'une **architecture SIEM hybride** (on-prem ↔ cloud)
- **Infrastructure as Code** avec Terraform et remote state
- Maîtrise du **KQL** : agrégations, `make_set`, `bin`, `case`, mapping d'entités
- **Détection alignée MITRE ATT&CK** et réflexion sur la réduction des faux positifs
- **Automatisation SOAR** : Logic Apps, règles d'automatisation, gestion des permissions
- Capacité à **diagnostiquer et contourner** les limitations d'interface en basculant sur Azure CLI / API REST
- Cycle de vie complet d'un incident : détection → triage → investigation → classification → réponse

---

## 👤 Auteur

**Ivan** — Apprenti Administrateur Systèmes & Réseaux · Master MICSI (Manager en Infrastructures et Cybersécurité des Systèmes d'Information)

---

*Projet personnel réalisé dans un environnement de lab à des fins d'apprentissage et de démonstration de compétences en ingénierie de sécurité cloud.*
