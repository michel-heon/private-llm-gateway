# EPOP-004 : Infrastructure as Code (IaC)

**Type** : Épopée  
**ID** : EPOP-004  
**Statut** : 📋 To Do  
**Sprint** : Sprint 3-4

---

## 📋 Vue d'Ensemble

**Objectif** : Automatiser le déploiement Azure avec Bicep/Terraform

**Valeur Métier** : Déploiement reproductible en <30 minutes

**Personas Concernés** :
- 🔴 Jordan (DevOps) — Critique

---

## 🎯 Objectifs

1. Créer templates Bicep pour Azure Relay
2. Créer templates Bicep pour HTTPS proxy (App Service / Container Apps)
3. Implémenter pipeline GitHub Actions CI/CD
4. Alternative Terraform (optionnel)

---

## 📊 Métriques de Succès

| Métrique | Cible | Actuel |
|----------|-------|--------|
| **Temps déploiement** | <30 minutes | 📊 Manuel actuel |
| **Reproductibilité** | 100% | 0% |
| **Environments gérés** | Dev + Prod | 0 |

---

## 🗂️ Récits Utilisateurs

| ID | Récit | Priorité | Effort | Statut |
|----|-------|----------|--------|--------|
| [RECIT-401](../Récits/RECIT-401-bicep-relay.md) | Template Bicep Azure Relay | Must Have | 8 pts | 📋 To Do |
| [RECIT-402](../Récits/RECIT-402-bicep-proxy.md) | Template Bicep HTTPS proxy | Must Have | 13 pts | 📋 To Do |
| [RECIT-403](../Récits/RECIT-403-github-actions.md) | GitHub Actions CI/CD | Should Have | 8 pts | 📋 To Do |
| [RECIT-404](../Récits/RECIT-404-terraform.md) | Alternative Terraform | Could Have | 13 pts | 📋 To Do |

**Total** : 4 récits, 42 points

---

## 📈 Progression

```
Progress: ░░░░░░░░░░░░░░░░░░░░ 0% (0/4 récits)
Points:   ░░░░░░░░░░░░░░░░░░░░ 0% (0/42 points)
```

**Récits complétés** : 0/4 (0%)  
**Points complétés** : 0/42 (0%)

---

## 🔗 Dépendances

### Dépendances Externes
- ☁️ Azure Subscription avec droits Contributor
- 🔧 Azure CLI installé et configuré
- 🐙 GitHub repository avec Actions enabled

### Dépendances Internes
- 🛠️ EPOP-002 complété (config management)
- 🔐 EPOP-003 en cours (Key Vault pour secrets)
- 📄 Décision ADR : Bicep vs Terraform vs azd (à créer)

---

## ⚠️ Risques Identifiés

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| Manque expertise Bicep | Élevée | Élevé | POC + tutorial Sprint 2 |
| Coûts Azure imprévus | Moyenne | Moyen | Budget alerts |
| Subscription test indispo | Faible | Élevé | Sandbox dédié |

---

## 🎓 Learnings et Décisions

### Décisions Techniques À Prendre
- [ ] **ADR-200** : Bicep vs Terraform vs azd
- [ ] **Proxy choice** : App Service vs Container Apps
- [ ] **Environments** : Dev/Staging/Prod ou Dev/Prod

### Architecture Cible
```
┌─────────────────┐
│  GitHub Actions │
└────────┬────────┘
         │ Deploy via Azure CLI
         ▼
┌─────────────────────────────────┐
│  Azure Resource Group           │
│                                 │
│  ┌───────────────┐             │
│  │ Azure Relay   │             │
│  │ Namespace     │             │
│  │               │             │
│  │ ├─ Hybrid    │             │
│  │ │  Connection│             │
│  └───────────────┘             │
│                                 │
│  ┌───────────────┐             │
│  │ App Service / │             │
│  │ Container App │             │
│  │ (HTTPS proxy) │             │
│  │               │             │
│  │ ├─ Custom     │             │
│  │ │  Domain     │             │
│  │ ├─ SSL Cert   │             │
│  └───────────────┘             │
│                                 │
│  ┌───────────────┐             │
│  │ Key Vault     │             │
│  │ (Secrets)     │             │
│  └───────────────┘             │
└─────────────────────────────────┘
```

---

## 📅 Timeline

| Phase | Début | Fin | Statut |
|-------|-------|-----|--------|
| **POC Bicep** | 2026-06-30 | 2026-07-03 | 📋 Recherche |
| **Template Relay** | 2026-07-04 | 2026-07-08 | 📋 Sprint 3 |
| **Template Proxy** | 2026-07-09 | 2026-07-15 | 📋 Sprint 3 |
| **GitHub Actions** | 2026-07-16 | 2026-07-17 | 📋 Sprint 3 |
| **Terraform (optionnel)** | 2026-07-18 | 2026-07-31 | 📋 Sprint 4 |

---

## 🔄 Historique

| Date | Action | Auteur |
|------|--------|--------|
| 2026-06-05 | Création épopée | Alex |

---

_Dernière mise à jour : 2026-06-05_
