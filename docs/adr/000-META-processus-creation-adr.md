---
# 🤖 Machine-Readable Metadata (Frontmatter YAML)
adr: 0
title: "Processus de Création et Gestion des ADR"
status: "accepted"
date: 2026-02-21
superseded_by: null
replaces: null
related_adrs: []
related_issues: []

# 🗂️ Taxonomie ADR
classification:
  lifecycle: "accepted"
  domain: "meta"
  impact: "critical"
  quality:
    - "maintainability"
    - "compliance"
  reversibility: "hard"
  scope: "strategic"
  tech_areas:
    - "documentation"
    - "git"

tags: ["process", "documentation", "meta-adr", "governance"]
stakeholders: ["@architecture-team", "@dev-team", "@private-llm-gateway"]
effort: "low"
---

# ADR 000: Processus de Création et Gestion des ADR

## ⚠️ Documents Complémentaires Obligatoires

**Ce processus est documenté dans un système cohérent de 4 fichiers à consulter ensemble**:

1. **[ADR-000](./000-META-processus-creation-adr.md)** - Ce fichier (processus et règles)
2. **[TAXONOMY.md](./TAXONOMY.md)** - Classification détaillée (7 dimensions)
3. **[adr-template-ai-optimized.md](./adr-template-ai-optimized.md)** - Template pratique
4. **[README.md](./README.md)** - Index et guide rapide

**⚡ Cohérence**: Toute modification des plages de numérotation, domaines ou classification doit être reflétée dans les 4 fichiers.

---

## ⚠️ Règle Critique : Mise à Jour du README à Chaque Nouvel ADR

**OBLIGATOIRE** : Après avoir créé ou accepté un ADR, [`docs/adr/README.md`](./README.md) **doit être mis à jour dans le même commit**.

### Pourquoi ?

1. **Invisibilité** : Un ADR absent de l'index est introuvable pour les nouveaux développeurs et les agents IA
2. **Statistiques fausses** : Les compteurs (total, par domaine) deviennent incorrects
3. **Prochains numéros erronés** : La table des plages disponibles induit des collisions de numérotation

### Checklist obligatoire à chaque création d'ADR

```bash
# Toujours committer README.md ET le nouvel ADR ensemble
git add docs/adr/XXX-CATÉGORIE-*.md docs/adr/README.md
git commit -m "docs(adr): ADR-XXX [CATÉGORIE] Titre court"
```

Dans `README.md`, mettre à jour :
- [ ] Table de la **catégorie correspondante** (ajouter la ligne de l'ADR)
- [ ] **Statistiques** : incrémenter `Total ADRs` et le compteur du domaine
- [ ] **Prochains disponibles** : avancer le prochain numéro libre de la plage

> ℹ️ La procédure détaillée est dans [§ Processus de Création → Étape 5 — Référencement](#5-référencement) ci-dessous.

---

---

## 📊 Vue d'Ensemble

| Attribut | Valeur |
|----------|--------|
| **Statut** | ✅ Accepté |
| **Date Décision** | 2026-05-08 |
| **Dernière Révision** | 2026-06-04 |
| **Stakeholders** | @architecture-team, @dev-team |
| **Impact** | 🔴 Critique (fondamental) |
| **Effort Implémentation** | 🟢 Faible |
| **Risque Technique** | 🟢 Faible |

## Statut

✅ Accepté

## Date

2026-05-08

## Contexte

Le projet **Private LLM Gateway** est un gateway HTTPS sécurisé pour exposer des LLMs locaux via une API compatible OpenAI. Le projet utilise Ollama pour l'exécution locale de modèles, LiteLLM comme gateway compatible OpenAI, Azure Relay Hybrid Connection pour la connectivité privée, et un proxy HTTPS Azure comme point d'entrée public.

Le projet vise à fournir une infrastructure sécurisée pour :

- l'exposition sécurisée de LLMs locaux via HTTPS
- la compatibilité avec les APIs OpenAI standard
- l'intégration avec VS Code BYOK / Copilot Chat
- la sécurisation de l'accès via Azure Relay Hybrid Connection
- l'authentification et l'autorisation au niveau du proxy Azure
- le maintien de la confidentialité en gardant les modèles en local

Ce projet nécessite une documentation structurée des décisions architecturales importantes. Les Architecture Decision Records (ADR) sont un moyen éprouvé de capturer le **pourquoi** derrière les décisions techniques, facilitant :

- La compréhension des choix architecturaux par les nouveaux développeurs
- La traçabilité des décisions dans le temps
- L'évaluation des alternatives considérées
- La documentation des conséquences (positives et négatives)
- La justification des changements futurs
- La cohérence avec les principes de souveraineté numérique et privacy-first

Sans processus formalisé, les décisions restent implicites, rendant difficile :

- La cohérence de la documentation
- La recherche de décisions passées
- La compréhension du contexte historique
- L'évaluation de la pertinence actuelle des décisions

## Décision

Adopter un processus formalisé de création et gestion des ADR basé sur le modèle Michael Nygard, adapté pour Private LLM Gateway.

### Structure des ADR

Chaque ADR suit le template **optimisé IA** : [`docs/adr/adr-template-ai-optimized.md`](./adr-template-ai-optimized.md)

Ce template inclut :

#### **Frontmatter YAML obligatoire** (machine-readable):
```yaml
---
adr: XXX
title: "Titre Descriptif"
status: "proposed"  # lifecycle state
date: YYYY-MM-DD
classification:
  lifecycle: "proposed"
  domain: "infrastructure"
  impact: "high"
  quality: ["security", "reliability"]
  reversibility: "moderate"
  scope: "tactical"
  tech_areas: ["python", "azure", "gateway"]
tags: ["process", "documentation", "meta-adr", "governance"]
stakeholders: ["@architecture-team", "@dev-team"]
effort: "medium"
---
```

#### **Sections obligatoires** (human-readable):
```markdown
# ADR XXX: Titre Court et Descriptif

## 📊 Vue d'Ensemble (tableau récapitulatif)

## 🎯 Contexte & Problème
[Description du problème avec questions guidées]

## ✅ Décision
[Solution choisie + principes appliqués]

## 📊 Matrice de Décision Quantifiée
[Tableau comparatif avec scores sur 10]

## ⚖️ Conséquences
### ✅ Positives (avec métriques)
### ⚠️ Négatives & Mitigations (tableau)

## 🔄 Alternatives Considérées
[Options rejetées avec scores matrice]

## 🚀 Plan d'Implémentation (phases tabulaires)

## 🎯 Critères de Succès & Validation (métriques SMART)

## 🔗 Traçabilité & Liens (ADRs/Issues/PRs)
```

### Numérotation et Convention de Nommage

#### Format Hybride (Numéro + Catégorie + Titre)

**Format standard** : `XXX-CATÉGORIE-titre-kebab-case.md`

**Structure**:
- `XXX` : Numéro séquentiel sur 3 chiffres (000-999), **par plage de catégorie**
- `CATÉGORIE` : Préfixe optionnel domaine en UPPER-CASE (4-6 lettres)
- `titre-kebab-case` : Titre descriptif en minuscules avec tirets

**Exemples propres au projet**:
```
000-META-processus-creation-adr.md              # Méta-ADR
100-ARCH-architecture-ia-locale-modulaire.md    # Architecture IA locale
200-INFRA-azure-relay-hybrid-connection.md      # Infrastructure Azure Relay
300-SEC-confidentialite-donnees-locales.md      # Sécurité & confidentialité
400-DATA-choix-vector-database.md               # Vector DB locale
500-API-litellm-openai-compatibility.md         # API OpenAI compatibility
600-DEVOPS-ci-cd-automation.md                  # CI/CD automation
700-TEST-benchmarks-llm-locaux.md               # Benchmarks LLM
800-BIZ-licensing-open-source.md                # Licensing Apache 2.0
```

#### Préfixes Catégories Standards

**Plages de numérotation réservées par préfixe** :

| Préfixe | Plage | Domaine | Usage |
|---------|-------|---------|-------|
| `META` | 000-099 | Méta-processus | ADRs sur le processus ADR lui-même |
| `ARCH` | 100-199 | Architecture | Design patterns, principes architecturaux IA locale |
| `INFRA` | 200-299 | Infrastructure | Déploiement Azure, networking, proxy HTTPS |
| `SEC` | 300-399 | Sécurité | Confidentialité, isolation réseau, chiffrement |
| `DATA` | 400-499 | Données | Modèles, configuration, persistance |
| `API` | 500-599 | APIs | Interfaces REST, OpenAI compatibility, LiteLLM |
| `DEVOPS` | 600-699 | DevOps | CI/CD, build automation, scripts |
| `TEST` | 700-799 | Tests & QA | Benchmarks LLM, tests qualité, validation |
| `BIZ` | 800-899 | Business | Licensing open-source, distribution |

**Règle catégorie obligatoire** : Utiliser le préfixe correspondant à la plage de numérotation. Si multi-domaines, choisir le domaine principal et utiliser la classification YAML pour les domaines secondaires.

#### Séquence Numérotation

- **Plages** : Chaque catégorie a sa plage réservée de 100 numéros
- **ADR 000** : Ce document (méta-ADR sur le processus)
- **Séquence par plage** : 000-001-002... (META), 100-101-102... (ARCH), 600-601-602... (DEVOPS)
- **Ordre de création** : Chronologique **au sein de chaque catégorie**

### États Possibles (Lifecycle)

| Emoji | État | Description | YAML Value |
|-------|------|-------------|------------|
| 🔄 | Brouillon | En cours de rédaction | `draft` |
| 🔄 | Proposé | Prêt pour revue/validation | `proposed` |
| ✅ | Accepté | Décision approuvée et appliquée | `accepted` |
| ❌ | Rejeté | Proposition refusée (archivée) | `rejected` |
| ⚠️ | Déprécié | Remplacé par un ADR plus récent | `deprecated` |
| ➡️ | Remplacé | Remplacé par un ADR plus récent (référencer l'ADR qui remplace) | `remplacé` |

### 🗂️ Taxonomie de Classification

Chaque ADR doit inclure une classification complète dans le frontmatter YAML:

#### 1. **Lifecycle** (Cycle de vie)
- `draft` → `proposed` → `accepted` / `rejected`
- `deprecated` / `remplacé` (pour ADRs obsolètes)

#### 2. **Domain** (Domaine architectural)
- `architecture`: Décisions architecturales de la plateforme IA locale
- `infrastructure`: Déploiement Azure, networking, proxy HTTPS
- `security`: Confidentialité, isolation réseau, chiffrement local
- `data`: Modèles, configuration, persistance
- `api`: Interfaces REST, OpenAI compatibility, LiteLLM
- `devops`: CI/CD, build automation, scripts
- `test`: Benchmarks LLM, tests qualité, validation
- `business`: Licensing open-source, distribution

#### 3. **Impact** (Niveau d'impact)
- `low`: Local, facilement réversible
- `medium`: Plusieurs composants, effort modéré
- `high`: Système-wide, breaking change possible
- `critical`: Fondamental, irréversible

#### 4. **Quality Attributes** (ASR - ISO 25010)
- `performance`: Latency, throughput, scalability (requests/s, overhead proxy)
- `security`: Confidentialité, isolation, chiffrement local
- `reliability`: Availability, fault tolerance, stabilité LLM local
- `maintainability`: Modularity, testability, upgradeability
- `cost`: Coût matériel, zéro cloud
- `usability`: Developer experience, facilité installation locale
- `compliance`: Licences open-source (Apache 2.0), RGPD
- `portability`: Multi-plateforme (macOS, Linux, Windows, ARM, x86)

#### 5. **Reversibility** (Facilité de changement)
- `easy`: < 1 jour, aucune dépendance
- `moderate`: 1-5 jours, dépendances locales
- `hard`: > 1 semaine, dépendances multiples
- `irreversible`: Migration impossible ou prohibitive

#### 6. **Scope** (Portée)
- `strategic`: Vision long terme, organisation-wide
- `tactical`: Implémentation spécifique, projet-wide
- `operational`: Choix techniques locaux, component-level

#### 7. **Tech Areas** (Domaines technologiques)
- Exemples pertinents : `python`, `azure`, `azure-relay`, `hybrid-connection`, `ollama`, `litellm`, `openai-api`, `https-proxy`, `api-gateway`, `authentication`, `caddy`, `nginx`, `vscode-byok`, `copilot`, `gateway`, `security`

### Processus de Création

#### 1. Identifier le Besoin

Un ADR est requis quand :

- ✅ Décision architecturale significative (gateway architecture, sécurité, networking)
- ✅ Choix ayant des conséquences à long terme
- ✅ Alternatives multiples existantes nécessitant justification
- ✅ Décision affectant plusieurs composants/équipes
- ✅ Choix non évident nécessitant explication
- ✅ Choix liant la confidentialité des données (privacy-first)

Un ADR n'est **pas** requis pour :

- ❌ Décisions triviales ou de routine
- ❌ Choix sans alternative viable
- ❌ Décisions temporaires ou expérimentales
- ❌ Préférences de style de code (utiliser linter)

#### 2. Créer le Fichier

**Procédure création**:

```bash
cd docs/adr

# 1. Déterminer la catégorie dominante de la décision
# Exemple: Décision sur choix vector DB locale → DATA (bloc 400)

# 2. Trouver le prochain numéro disponible dans le bloc
ls -1 4*.md | tail -1  # Dernier DATA (ex: 401)

# 3. Créer avec numéro suivant + préfixe catégorie
cp adr-template-ai-optimized.md 402-DATA-nouvelle-decision.md

# 4. ⚠️ OBLIGATOIRE : Mettre à jour l'index des ADRs
#    Ajouter l'entrée dans la table de la catégorie appropriée
vi README.md
```

> **📋 Rappel** : La mise à jour de [`docs/adr/README.md`](./README.md) est **obligatoire** à chaque création d'ADR.
> Un ADR absent de l'index est invisible pour l'équipe et les agents IA. Voir [étape 5 — Référencement](#5-référencement) pour la procédure complète.

#### 3. Rédiger l'ADR

**Ordre de rédaction recommandé** :

1. **Frontmatter YAML** : Remplir métadonnées + classification complète
2. **Contexte** : Décrire le problème avec questions guidées
3. **Alternatives** : Lister options avec matrice décision quantifiée (scores/10)
4. **Décision** : Solution choisie + principes architecturaux
5. **Conséquences** : Impacts avec métriques quantifiées
6. **Plan implémentation** : Phases tabulaires avec dépendances
7. **Critères succès** : Métriques SMART + triggers review
8. **Traçabilité** : Liens bidirectionnels ADRs/Issues/PRs

**Conseils de rédaction** :

- ✍️ Écrire au **présent** : "Nous décidons" (pas "Nous avons décidé")
- 🎯 Être **spécifique** : Noms de technologies, versions, configurations
- 📊 **Quantifier** : Scores matrice décision, métriques succès
- 📈 **Tableaux structurés** : Facilite parsing automatique par agents IA
- 🔗 **Référencer** : Liens vers docs externes, autres ADRs, code annoté `@ADR`
- ⚖️ Rester **objectif** : Présenter les faits, pas les opinions
- 🗂️ **Classifier** : Remplir taxonomie complète (domain, impact, quality, etc.)

#### 4. Revue et Validation

**Lifecycle ADR** :
- **Brouillon** (`draft`) : Rédaction initiale, peut contenir TODOs
- **Proposé** (`proposed`) : Prêt pour discussion avec l'équipe
- **Accepté** (`accepted`) : Décision finale, implémentation peut commencer

**Critères de validation** :
- ✅ Frontmatter YAML complet et valide
- ✅ Classification taxonomie remplie (7 dimensions)
- ✅ Matrice décision quantifiée (si alternatives)
- ✅ Métriques succès SMART définies
- ✅ Aucun placeholder `[...]` restant
- ✅ Review par au moins 1 stakeholder (pour impact `high`/`critical`)

#### 5. Référencement

> **⚠️ Rappel Important**: Cette étape est **obligatoire** mais **fréquemment omise**.  
> Un ADR non référencé dans le README est **invisible** pour les nouveaux développeurs et l'IA.

##### 5.1. Mettre à jour `docs/adr/README.md`

Ajouter l'entrée dans la table de la catégorie appropriée et mettre à jour les statistiques.

##### 5.2. Checklist Référencement

Avant de commiter, vérifier :

- [ ] ✅ Entrée ajoutée dans `docs/adr/README.md` (table principale)
- [ ] ✅ **Statistiques** mises à jour (total, par domaine)
- [ ] ✅ `README.md` (racine) mis à jour si impact `high`/`critical`

#### 6. Commit Git

```bash
git add docs/adr/XXX-CATÉGORIE-*.md docs/adr/README.md
git commit -m "docs(adr): ADR-XXX [CATÉGORIE] Titre court

Classification:
- Domain: infrastructure
- Impact: high
- Scope: tactical

Référence: #issue (si applicable)"
```

### Modification des ADR Existants

**Ne JAMAIS modifier** un ADR accepté pour changer la décision :

1. Créer un **nouvel ADR** avec la nouvelle décision
2. Marquer l'ancien ADR comme **Supersédé** (➡️)
3. Ajouter référence croisée entre les deux ADRs

## Conséquences

### Positives ✅

- **Traçabilité** : Historique complet des décisions architecturales
- **Onboarding** : Nouveaux développeurs comprennent rapidement les choix
- **Cohérence** : Format standard facilite la recherche et compréhension
- **Conformité** : Rationale documenté facilite l'audit RGPD et la vérification des licences open-source
- **Documentation vivante** : ADRs évoluent avec le code dans le même repo

### Négatives ⚠️

- **Overhead initial** : Temps requis pour rédiger un ADR (~30-60 minutes)
- **Discipline requise** : Nécessite rigueur pour maintenir la pratique

### Mitigations 🔧

- **Template pré-rempli** : `adr-template-ai-optimized.md` accélère la rédaction
- **Critères clairs** : Section "Identifier le Besoin" guide quand créer un ADR

## 🚀 Plan d'Implémentation

| Phase | Durée | Deliverables | Status |
|-------|-------|--------------|--------|
| **Phase 1: Fondation** | 1 jour | ADR-000, TAXONOMY, template | ✅ Complété |
| **Phase 2: ADRs Initiaux** | 1-2 semaines | ADRs architecture principale | 🔄 En cours |
| **Phase 3: Automation** | À planifier | Scripts validation + CI check | 📋 Backlog |

## 🎯 Critères de Succès

| Métrique | Valeur Cible |
|----------|--------------|
| ADRs avec frontmatter YAML | 100% |
| Conformité taxonomie | ≥ 90% |
| Temps création ADR | < 60 min |

---

## 📚 Références

- [Architecture Decision Records](https://adr.github.io/)
- [Michael Nygard - Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- [Joel Parker Henderson - ADR](https://github.com/joelparkerhenderson/architecture-decision-record)
- [Ollama](https://ollama.com/)
- [LiteLLM](https://docs.litellm.ai/)
- [Azure Relay](https://learn.microsoft.com/azure/azure-relay/)
- [Private LLM Gateway GitHub](https://github.com/michel-heon/private-llm-gateway)

---

## 📝 Notes & Historique

| Date | Auteur | Changement | Raison |
|------|--------|------------|--------|
| 2026-06-04 | @architecture-team | Adaptation pour Private LLM Gateway | Adaptation du template ADR pour private-llm-gateway |
