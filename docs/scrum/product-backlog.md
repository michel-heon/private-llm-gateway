# Product Backlog — Private LLM Gateway

**Organisation** : Index principal du backlog avec liens vers fichiers individuels.  
Priorisation selon méthode **MoSCoW** (Must, Should, Could, Won't).

---

## 📊 Vue d'Ensemble

| Métrique | Valeur |
|----------|--------|
| **Total Épopées** | 5 |
| **Total Récits** | 23 |
| **Must Have** | 12 récits |
| **Should Have** | 7 récits |
| **Could Have** | 4 récits |
| **Points Totaux** | ~140 story points |

**Prochains sprints planifiés** :
- **Sprint 1** (2026-06-05 → 2026-06-19) : Epic 1 (macMLX) + Epic 2 (DevOps) 
- **Sprint 2** (2026-06-20 → 2026-07-03) : Epic 3 (Sécurité)
- **Sprint 3** (2026-07-04 → 2026-07-17) : Epic 4 (IaC) + Epic 5 (Monitoring)

---

## 📁 Structure du Backlog

```
docs/scrum/backlog/
├── Épopées/              # 5 épopées
│   ├── EPOP-001-support-macmlx.md
│   ├── EPOP-002-patterns-devops.md
│   ├── EPOP-003-securite.md
│   ├── EPOP-004-infrastructure-as-code.md
│   └── EPOP-005-observabilite-monitoring.md
└── Récits/               # 23 récits utilisateurs
    ├── RECIT-101-doc-macmlx.md
    ├── RECIT-102-scripts-macmlx.md
    ├── ...
    └── RECIT-504-logs-json.md
```

---

## 🎯 [Epic 1 : Support macMLX Complet](backlog/Épopées/EPOP-001-support-macmlx.md)

**Objectif** : Offrir macMLX comme alternative performante à Ollama sur Apple Silicon  
**Valeur Métier** : 2x speedup pour les utilisateurs Mac M1/M2/M3/M4  
**Points** : 23 | **Statut** : 🟢 En cours

### Récits Utilisateurs

| ID | Titre | Priorité | Effort | Sprint | Statut |
|----|-------|----------|--------|--------|--------|
| [RECIT-101](backlog/Récits/RECIT-101-doc-macmlx.md) | Documenter installation macMLX | Must Have | 2 pts | S1 | ✅ Complété |
| [RECIT-102](backlog/Récits/RECIT-102-scripts-macmlx.md) | Créer scripts start/stop macMLX | Must Have | 3 pts | S1 | 📋 To Do |
| [RECIT-103](backlog/Récits/RECIT-103-litellm-macmlx.md) | Configurer LiteLLM pour macMLX | Must Have | 5 pts | S1 | 📋 To Do |
| [RECIT-104](backlog/Récits/RECIT-104-tests-validation.md) | Tester end-to-end VS Code → macMLX | Must Have | 8 pts | S1 | 📋 To Do |
| [RECIT-105](backlog/Récits/RECIT-105-benchmark-perf.md) | Benchmark Ollama vs macMLX | Should Have | 5 pts | S2 | 📋 To Do |

**Total Epic 1** : 23 points

---

## 🛠️ [Epic 2 : Patterns DevOps Standardisés](backlog/Épopées/EPOP-002-patterns-devops.md)

**Objectif** : Uniformiser scripts, configuration, et workflows  
**Valeur Métier** : Réduction friction onboarding et maintenance  
**Points** : 27 | **Statut** : 🟡 Planifié

### Récits Utilisateurs

| ID | Titre | Priorité | Effort | Sprint | Statut |
|----|-------|----------|--------|--------|--------|
| [RECIT-201](backlog/Récits/RECIT-201-bootstrap-config.md) | Bootstrap configuration multi-format | Must Have | 8 pts | S1 | 📋 To Do |
| [RECIT-202](backlog/Récits/RECIT-202-makefile-orchestrateur.md) | Makefile orchestrateur principal | Must Have | 8 pts | S1 | 📋 To Do |
| [RECIT-203](backlog/Récits/RECIT-203-nomenclature-scripts.md) | Standardiser nomenclature scripts | Should Have | 3 pts | S1 | 📋 To Do |
| [RECIT-204](backlog/Récits/RECIT-204-couleurs-ansi.md) | Ajouter couleurs ANSI aux scripts | Should Have | 3 pts | S2 | 📋 To Do |
| [RECIT-205](backlog/Récits/RECIT-205-parsing-options-bash.md) | Parsing options Bash standard | Should Have | 5 pts | S2 | 📋 To Do |

**Total Epic 2** : 27 points

---

## 🔐 [Epic 3 : Sécurité Production-Ready](backlog/Épopées/EPOP-003-securite.md)

**Objectif** : Protéger secrets, logs, et accès réseau  
**Valeur Métier** : Conformité entreprise et réduction risques  
**Points** : 23 | **Statut** : 🟡 Planifié

### Récits Utilisateurs

| ID | Titre | Priorité | Effort | Sprint | Statut |
|----|-------|----------|--------|--------|--------|
| [RECIT-301](backlog/Récits/RECIT-301-azure-key-vault.md) | Intégrer Azure Key Vault pour secrets | Must Have | 8 pts | S2 | 📋 To Do |
| [RECIT-302](backlog/Récits/RECIT-302-log-redaction.md) | Implémenter log redaction | Must Have | 5 pts | S2 | 📋 To Do |
| [RECIT-303](backlog/Récits/RECIT-303-rate-limiting.md) | Rate limiting au proxy Azure | Must Have | 5 pts | S2 | 📋 To Do |
| [RECIT-304](backlog/Récits/RECIT-304-threat-model.md) | Créer threat model diagram | Should Have | 5 pts | S3 | 📋 To Do |

**Total Epic 3** : 23 points

---

## ☁️ [Epic 4 : Infrastructure as Code](backlog/Épopées/EPOP-004-infrastructure-as-code.md)

**Objectif** : Automatiser provisionning Azure avec IaC  
**Valeur Métier** : Reproductibilité et disaster recovery  
**Points** : 42 | **Statut** : 🟡 Planifié

### Récits Utilisateurs

| ID | Titre | Priorité | Effort | Sprint | Statut |
|----|-------|----------|--------|--------|--------|
| [RECIT-401](backlog/Récits/RECIT-401-bicep-relay.md) | Template Bicep pour Azure Relay | Must Have | 8 pts | S3 | 📋 To Do |
| [RECIT-402](backlog/Récits/RECIT-402-bicep-proxy.md) | Template Bicep pour HTTPS proxy | Must Have | 13 pts | S3 | 📋 To Do |
| [RECIT-403](backlog/Récits/RECIT-403-github-actions.md) | GitHub Actions workflow CI/CD | Should Have | 8 pts | S3 | 📋 To Do |
| [RECIT-404](backlog/Récits/RECIT-404-terraform.md) | Alternative Terraform pour IaC | Could Have | 13 pts | S4 | 📋 To Do |

**Total Epic 4** : 42 points

---

## 📈 [Epic 5 : Observabilité & Monitoring](backlog/Épopées/EPOP-005-observabilite-monitoring.md)

**Objectif** : Visibilité opérationnelle complète (métriques, logs, traces)  
**Valeur Métier** : Détection proactive incidents et optimisation performance  
**Points** : 31 | **Statut** : 🟡 Planifié

### Récits Utilisateurs

| ID | Titre | Priorité | Effort | Sprint | Statut |
|----|-------|----------|--------|--------|--------|
| [RECIT-501](backlog/Récits/RECIT-501-application-insights.md) | Intégrer Application Insights | Must Have | 8 pts | S3 | 📋 To Do |
| [RECIT-502](backlog/Récits/RECIT-502-health-checks.md) | Endpoints /health et /ready | Must Have | 5 pts | S2 | 📋 To Do |
| [RECIT-503](backlog/Récits/RECIT-503-grafana-dashboard.md) | Dashboard Grafana (optionnel) | Could Have | 13 pts | S4 | 📋 To Do |
| [RECIT-504](backlog/Récits/RECIT-504-logs-json.md) | Logs structurés JSON | Should Have | 5 pts | S3 | 📋 To Do |

**Total Epic 5** : 31 points

---

## 📈 Résumé Priorisation

| Epic | Must Have | Should Have | Could Have | Total Points | Sprint Target |
|------|-----------|-------------|------------|--------------|---------------|
| **Epic 1 (macMLX)** | 2 récits (5 pts) | 1 récit (2 pts) | 1 récit (5 pts) | 23 pts | Sprint 1 |
| **Epic 2 (DevOps)** | 2 récits (16 pts) | 3 récits (11 pts) | 0 | 27 pts | Sprint 1-2 |
| **Epic 3 (Sécurité)** | 3 récits (18 pts) | 1 récit (5 pts) | 0 | 23 pts | Sprint 2 |
| **Epic 4 (IaC)** | 2 récits (21 pts) | 1 récit (8 pts) | 1 récit (13 pts) | 42 pts | Sprint 3-4 |
| **Epic 5 (Monitoring)** | 2 récits (13 pts) | 1 récit (5 pts) | 1 récit (13 pts) | 31 pts | Sprint 3-4 |

**Vélocité estimée** : 20-25 points/sprint (ajustable après Sprint 1)

---

## 🗑️ Won't Have (Hors Scope)

Ces fonctionnalités sont explicitement **exclues** du backlog actuel :

- ❌ Support des inférences GPU cloud (AWS SageMaker, Azure ML)
- ❌ Multi-tenancy avec isolation complète par client
- ❌ Remplacement de GitHub Copilot inline completions
- ❌ Support Windows pour l'agent local (macOS/Linux uniquement)
- ❌ Interface web de gestion (CLI only)

---

## 📝 Maintenance du Backlog

- **Review Hebdomadaire** : Ajustement des priorités après chaque sprint
- **Grooming Bi-Hebdomadaire** : Estimation des nouveaux récits
- **Liens** : Tous les récits référencent leur épopée parente
- **Statuts** : Mis à jour en temps réel (✅ Complété | 🚧 En Cours | 📋 To Do)

---

_Dernière mise à jour : 2026-06-05_
