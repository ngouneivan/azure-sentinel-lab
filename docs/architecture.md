# Architecture du lab

## Schéma

Sources → Log Analytics Workspace → Microsoft Sentinel → Incidents → Logic App

## Composants
- **Log Analytics Workspace** : law-sentinel-lab
- **Microsoft Sentinel** : SIEM activé sur le workspace
- **Connecteurs** : Windows Security Events, Entra ID, Azure Arc
- **Règles KQL** : Brute Force RDP, Connexion suspecte, Création compte
- **Playbook** : Notification email sur incident High
