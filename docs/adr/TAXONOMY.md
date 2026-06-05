# 🗂️ Taxonomie ADR - Guide de Classification

**Version**: 2.0  
**Date**: 2026-06-05  
**Projet**: private-llm-gateway  
**Basée sur**: Bonnes pratiques industrie (GitHub ADR Organization, Joel Parker Henderson, AWS Prescriptive Guidance)

---

## ⚠️ Documents Complémentaires

**Ce document fait partie d'un système cohérent de 4 fichiers**:

1. **[ADR-000](./000-META-processus-creation-adr.md)** - Processus et numérotation
2. **[TAXONOMY.md](./TAXONOMY.md)** - Ce fichier (classification détaillée)
3. **[adr-template-ai-optimized.md](./adr-template-ai-optimized.md)** - Template pratique
4. **[README.md](./README.md)** - Index et vue d'ensemble

**⚡ IMPORTANT**: Toute modification de classification ici doit être reflétée dans le template et ADR-000.

---

## 📋 Vue d'Ensemble

Cette taxonomie permet de **classifier chaque ADR selon 7 dimensions** pour:
- ✅ Faciliter la recherche et le filtrage
- ✅ Permettre le parsing automatique par agents IA
- ✅ Construire des graphes de dépendances
- ✅ Générer des dashboards automatiques

**Format**: Frontmatter YAML dans chaque ADR (voir template)

---

## 🔍 Les 7 Dimensions de Classification

### 1️⃣ Lifecycle (Cycle de Vie)

**État actuel de l'ADR dans son cycle de vie**

| Valeur | Description | Emoji | Usage |
|--------|-------------|-------|-------|
| `draft` | Rédaction en cours, peut contenir TODOs | 🔄 | ADR incomplet |
| `proposed` | Prêt pour review équipe | 🔄 | En attente validation |
| `accepted` | Décision approuvée et en vigueur | ✅ | Implémenté |
| `rejected` | Proposition refusée (archivée) | ❌ | Non retenu |
| `deprecated` | Obsolète mais pas remplacé | ⚠️ | À retirer |
| `remplacé` | Remplacé par nouvel ADR | ➡️ | Référencer nouveau |

**Exemple**:
```yaml
classification:
  lifecycle: "accepted"
```

---

### 2️⃣ Domain (Domaine Architectural)

**Domaine architectural principal concerné**

**Plages de numérotation réservées par domaine** :

| Préfixe | Plage | Domaine | Exemples ADR private-llm-gateway |
|---------|-------|---------|-----------------------------------|
| `META` | 000-099 | Méta-processus | ADR-000: Processus ADR |
| `ARCH` | 100-199 | Architecture | ADR-100: Architecture gateway sécurisé |
| `INFRA` | 200-299 | Infrastructure | ADR-200: Infrastructure Azure, déploiement |
| `SEC` | 300-399 | Sécurité | ADR-300: Authentification proxy, TLS/HTTPS |
| `DATA` | 400-499 | Données | ADR-400: Format requêtes OpenAI, logs |
| `API` | 500-599 | API/Intégrations | ADR-500: Compatibilité OpenAI API, LiteLLM |
| `DEVOPS` | 600-699 | DevOps | ADR-600: Configuration, scripts, Makefile |
| `TEST` | 700-799 | Tests & QA | ADR-700: Tests intégration gateway |
| `BIZ` | 800-899 | Business | ADR-800: Modèle déploiement, licensing |
| `DOC` | 900-999 | Documentation | ADR-900: Documentation utilisateur |

**Descriptions par domaine** :

| Valeur | Description | Exemples contexte private-llm-gateway |
|--------|-------------|----------------------------------------|
| `architecture` | Décisions architecturales gateway | Patterns Azure Relay + LiteLLM + Ollama |
| `infrastructure` | Infrastructure Azure, networking | Azure Relay, proxy HTTPS, DNS, Hybrid Connection |
| `security` | Authentification, TLS, confidentialité | Authentification Azure, TLS termination, secrets |
| `data` | Formats données, logs, métriques | Format requêtes OpenAI, logs gateway |
| `api` | Interfaces API, compatibilité OpenAI | API LiteLLM, endpoints OpenAI, VS Code BYOK |
| `devops` | CI/CD, automatisation, configuration | Scripts bash, Makefile, configuration multi-format |
| `test` | Tests, validation, monitoring | Tests endpoints, intégration gateway |
| `business` | Déploiement, coûts, licensing | Modèle déploiement hybride, coûts Azure |

**Exemple**:
```yaml
classification:
  domain: "infrastructure"
```

**Règle**: Choisir **UN seul domaine principal** (le plus impacté).

---

### 3️⃣ Impact (Niveau d'Impact)

**Ampleur de l'impact sur le système**

| Valeur | Description | Critères | Réversibilité Typique |
|--------|-------------|----------|----------------------|
| `low` | Impact local, facilement réversible | Single component, < 1 jour | Easy |
| `medium` | Plusieurs composants, effort modéré | Multi-component, 1-5 jours | Moderate |
| `high` | Système-wide, breaking change possible | Cross-system, > 1 semaine | Hard |
| `critical` | Fondamental, irréversible | Core architecture, migration coûteuse | Irreversible |

**Aide décision (contexte private-llm-gateway)**:
- **Low**: Changement paramètre LiteLLM, configuration Ollama mineure
- **Medium**: Changement format configuration, ajustement Azure Relay
- **High**: Migration proxy (Caddy → Nginx), changement authentification
- **Critical**: Choix Azure Relay, architecture gateway de base

---

### 4️⃣ Quality Attributes (Attributs Qualité - ASR)

**Qualités système affectées (basé sur ISO 25010)**

| Valeur | Description | Métriques Typiques | Pertinence private-llm-gateway |
|--------|-------------|-------------------|---------------------------------|
| `performance` | Latence, débit, scalabilité | p95 latency, req/s | Latence gateway < 200ms, débit LiteLLM |
| `security` | Auth, encryption, isolation | CVE count, TLS grade | TLS/HTTPS, authentification Azure, secrets |
| `reliability` | Disponibilité, tolérance pannes | Uptime %, MTBF | Stabilité Azure Relay, reprise agent local |
| `maintainability` | Modularité, testabilité | Test coverage | Architecture modulaire Python, scripts bash |
| `cost` | Infrastructure, licensing | $/mois | Coûts Azure Relay, VM proxy, bandwidth |
| `usability` | Developer experience | Time to deploy | Setup < 30min, intégration VS Code BYOK |
| `compliance` | Légal, réglementaire | RGPD, certifications | Confidentialité données, isolation réseau |
| `portability` | Multi-plateforme | Migration effort | macOS, Linux, Windows pour agent local |

**Exemple**:
```yaml
classification:
  quality:
    - "security"
    - "reliability"
    - "performance"
```

---

### 5️⃣ Reversibility (Facilité de Changement)

**Effort requis pour changer cette décision**

| Valeur | Effort | Durée Typique | Dépendances |
|--------|--------|---------------|-------------|
| `easy` | Très faible | < 1 jour | Aucune ou locale |
| `moderate` | Moyen | 1-5 jours | Quelques composants |
| `hard` | Élevé | > 1 semaine | Multiples systèmes |
| `irreversible` | Impossible/Prohibitif | Migration complète | Critique, données |

**Aide décision (contexte private-llm-gateway)**:
- **Easy**: Changement port LiteLLM, paramètre agent local
- **Moderate**: Changement proxy (Caddy ↔ Nginx), format configuration
- **Hard**: Migration Azure Relay (changement namespace, credentials)
- **Irreversible**: Changement architecture gateway (Azure Relay → autre solution)

---

### 6️⃣ Scope (Portée)

**Niveau stratégique de la décision**

| Valeur | Description | Horizon Temporel | Niveau |
|--------|-------------|------------------|--------|
| `strategic` | Vision long terme, organisation-wide | 3-5 ans | C-level, CTO |
| `tactical` | Implémentation spécifique, projet-wide | 6-18 mois | Team lead, Architect |
| `operational` | Choix techniques locaux, component-level | 1-6 mois | Developer |

**Aide décision (contexte private-llm-gateway)**:
- **Strategic**: Choix Azure Relay comme solution de connectivité privée
- **Tactical**: Architecture LiteLLM + Ollama, stratégie authentification Azure
- **Operational**: Configuration LiteLLM, scripts bash, paramètres agent local

---

### 7️⃣ Tech Areas (Domaines Technologiques)

**Technologies/frameworks/plateformes concernés** (liste libre)

#### Languages & Runtimes
- `python`, `bash`, `javascript` (optionnel)

#### Gateway & LLM
- `litellm`, `ollama`, `openai-api`, `gateway`, `llm-proxy`

#### Azure
- `azure`, `azure-relay`, `hybrid-connection`, `azure-proxy`, `azure-functions` (optionnel)

#### Networking & Security
- `https`, `tls`, `caddy`, `nginx`, `reverse-proxy`, `authentication`

#### DevOps & CI/CD
- `github-actions`, `bash-script`, `makefile`, `docker`, `docker-compose`

#### VS Code & Copilot
- `vscode`, `copilot`, `byok`, `copilot-chat`

#### Infrastructure
- `dns`, `godaddy`, `cloudflare` (optionnel)

**Exemple**:
```yaml
classification:
  tech_areas:
    - "python"
    - "azure"
    - "azure-relay"
    - "litellm"
    - "ollama"
    - "https"
```

---

## 📊 Exemple Complet

### ADR-200: Infrastructure Azure pour private-llm-gateway

```yaml
---
adr: 200
title: "Infrastructure Azure pour private-llm-gateway"
status: "proposed"
date: 2026-06-05

classification:
  lifecycle: "proposed"
  domain: "infrastructure"
  impact: "high"
  quality:
    - "reliability"
    - "security"
    - "performance"
  reversibility: "hard"
  scope: "tactical"
  tech_areas:
    - "azure"
    - "azure-relay"
    - "hybrid-connection"
    - "https"
    - "caddy"

tags: ["azure", "relay", "hybrid-connection", "https"]
stakeholders: ["@architecture-team", "@dev-team"]
---
```

---

## 🔎 Cas d'Usage

### Recherche par Domain
```bash
# Tous les ADRs infrastructure
grep -l 'domain: "infrastructure"' docs/adr/*.md
```

### Filtrage par Impact
```bash
# ADRs critiques seulement
grep -l 'impact: "critical"' docs/adr/*.md
```

### ADRs concernant la sécurité
```bash
grep -l '"security"' docs/adr/*.md
```

### Recherche par tech_area Azure Relay
```bash
grep -l '"azure-relay"' docs/adr/*.md
```

---

## ✅ Checklist Validation Classification

Avant d'accepter un ADR, vérifier:

- [ ] **Lifecycle**: État cohérent avec contenu ADR
- [ ] **Domain**: UN seul domaine principal choisi
- [ ] **Impact**: Niveau justifié dans section Conséquences
- [ ] **Quality**: ≥ 1 attribut qualité listé
- [ ] **Reversibility**: Cohérent avec impact et scope
- [ ] **Scope**: Aligné avec stakeholders et horizon
- [ ] **Tech Areas**: ≥ 1 technologie listée

---

## 🏷️ Convention Nommage Fichiers (Format Hybride)

### Format Standard

**Pattern** : `XXX-CATÉGORIE-titre-kebab-case.md`

### Exemples private-llm-gateway

```
000-META-processus-creation-adr.md                # META: 000-099
100-ARCH-architecture-gateway-securise.md         # ARCH: 100-199
200-INFRA-azure-relay-hybrid-connection.md        # INFRA: 200-299
300-SEC-authentification-azure-proxy.md           # SEC: 300-399
400-DATA-format-requetes-openai.md                # DATA: 400-499
500-API-litellm-openai-compatibility.md           # API: 500-599
600-DEVOPS-bootstrap-configuration-management.md  # DEVOPS: 600-699
700-TEST-integration-gateway-tests.md             # TEST: 700-799
800-BIZ-modele-deploiement-hybride.md             # BIZ: 800-899
```

### Commandes Recherche par Catégorie

```bash
# ADRs infrastructure
ls -1 docs/adr/*-INFRA-*.md

# ADRs sécurité ET devops
ls -1 docs/adr/*-{SEC,DEVOPS}-*.md

# Comptage par catégorie
ls -1 docs/adr/*.md | grep -oE "[A-Z]+" | sort | uniq -c
```

---

## 📚 Références

### Standards Industrie
- **ISO 25010**: System and software quality models
- **Privacy by Design**: 7 principes RGPD-friendly
- **Azure Architecture Framework**: Best practices Azure

### Bonnes Pratiques ADR
- [Joel Parker Henderson - ADR GitHub](https://github.com/joelparkerhenderson/architecture-decision-record)
- [ADR.github.io](https://adr.github.io/)
- [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/)

---

## 📝 Notes

**Évolution**: Cette taxonomie peut évoluer avec le projet. Si changement majeur, créer nouvel ADR et superseder ADR-000.

**Contexte spécifique private-llm-gateway**: La classification `security` et `privacy` est particulièrement importante dans ce projet en raison de :
- Exposition HTTPS publique de LLMs privés
- Authentification et autorisation via Azure
- Confidentialité des requêtes utilisateur (VS Code Copilot)
- Isolation réseau via Azure Relay Hybrid Connection

---

**Version**: 2.0  
**Maintenu par**: @architecture-team  
**Dernière mise à jour**: 2026-06-05  
**Projet**: private-llm-gateway  
**Repo**: https://github.com/michel-heon/private-llm-gateway
