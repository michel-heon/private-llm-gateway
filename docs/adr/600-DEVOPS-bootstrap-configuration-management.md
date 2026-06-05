---
adr: 600
title: "Gestion Multi-Format des Variables de Configuration"
status: "accepted"
date: 2026-06-05
superseded_by: null
replaces: null
related_adrs: [200, 601, 602, 603]
related_issues: []

classification:
  lifecycle: "accepted"
  domain: "devops"
  impact: "medium"
  quality:
    - "maintainability"
    - "security"
    - "usability"
    - "portability"
  reversibility: "moderate"
  scope: "tactical"
  tech_areas:
    - "bash"
    - "python"
    - "dotenv"
    - "makefile"
    - "docker"

tags: ["configuration", "environment", "secrets", "config", "multi-format", "source-of-truth", "devops"]
stakeholders: ["@dev-team", "@devops-team"]
effort: "low"
---

# ADR 600: Gestion Multi-Format des Variables de Configuration

## 📊 Vue d'Ensemble

| Attribut | Valeur |
|----------|--------|
| **Statut** | ✅ Accepté |
| **Date Décision** | 2026-06-05 |
| **Stakeholders** | @dev-team, @devops-team |
| **Impact** | 🟡 Moyen (workflow développeur + interopérabilité outils) |
| **Effort Implémentation** | 🟢 Faible |
| **Risque Technique** | 🟢 Faible |

## ⚠️ Règle Critique : Non-Édition Manuelle des Fichiers Générés

**INTERDICTION ABSOLUE** : Les fichiers dans `config/generated/` sont **auto-générés** et **ne doivent JAMAIS être édités manuellement**.

```bash
# ✅ CORRECT : Éditer la source, puis régénérer
nano .env                            # Surcharger un paramètre non-secret
nano .env.user                       # Renseigner un secret local
make config-generate                 # Régénérer config/generated/

# ❌ INCORRECT : Éditer directement les fichiers générés
nano config/generated/env.sh         # INTERDIT — sera écrasé
nano config/generated/env.docker     # INTERDIT — sera écrasé
```

## Contexte

Le projet **private-llm-gateway** nécessite une gestion sécurisée de la configuration lisible par plusieurs runtimes (Bash, Docker Compose, Python, Make).

### Problèmes identifiés

1. **Secrets exposés** : Clés API Azure, tokens Relay, ou chemins privés présents en clair dans fichiers versionés
2. **Formats multiples non synchronisés** : Bash, Makefile, Docker Compose, Python requièrent des syntaxes différentes
3. **Complexité d'installation** : Processus manuel sujet aux erreurs
4. **Emplacement non conventionnel** : `env/` n'est pas l'emplacement attendu par les outils dotenv, Docker Compose et les IDEs

### Contraintes

- Secrets ne doivent **jamais** être versionés dans Git (clés Azure, connection strings Relay, tokens)
- Support de 4 formats : scripts Bash, Makefile, Docker Compose, Python dotenv
- Configuration doit être simple pour nouveaux contributeurs (< 5 min)
- Pas de dépendance externe (Python stdlib uniquement)

## Décision

Adopter un système de configuration à **trois couches de sources** avec génération vers **quatre formats cibles**, orchestré par `scripts/config-init.sh`.

### Architecture de fichiers

```
Racine du projet
├── config/
│   ├── azure-proxy.example.env      # ① Template Azure proxy (versioné)
│   ├── local-agent.example.env      # ① Template agent local (versioné)
│   ├── litellm.example.yaml         # ① Config LiteLLM (versioné)
│   └── generated/                   # Fichiers générés — NE PAS ÉDITER
│       ├── .gitkeep                 #   Seul fichier tracké dans ce répertoire
│       ├── env.sh                   #   Format Bash    (source config/generated/env.sh)
│       ├── env.docker               #   Format Docker  (docker compose --env-file ...)
│       └── env.mk                   #   Format Make    (include config/generated/env.mk)
│
├── .env.example                     # Template .env versioné (copié → .env)
├── .env.user.example                # Template secrets versioné (copié → .env.user)
├── .env                             # ② Surcharges locales non-secrètes — NON versioné
└── .env.user                        # ③ Secrets locaux — NON versioné
```

### Couches de priorité (croissante)

| Priorité | Fichier | Versioné | Contenu |
|----------|---------|-----------|---------|
| 1 (base) | `config/*.example.env` | ✅ Oui | Toutes les variables avec valeurs par défaut sûres |
| 2 | `.env` | ❌ Non | Surcharges non-secrètes propres à la machine (ports, chemins locaux...) |
| 3 (max) | `.env.user` | ❌ Non | Secrets (Azure connection strings, Relay tokens, credentials) |

**Règle** : une clé présente dans plusieurs fichiers est résolue par le dernier fichier (priorité max). Les clés absentes de `.env` ou `.env.user` héritent automatiquement des fichiers example.

### Formats générés

| Fichier | Format | Usage |
|---------|--------|-------|
| `config/generated/env.sh` | `export KEY="value"` | `source config/generated/env.sh` dans les scripts Bash |
| `config/generated/env.docker` | `KEY=value` | `docker compose --env-file config/generated/env.docker` |
| `config/generated/env.mk` | `KEY ?= value` | `include config/generated/env.mk` dans Makefile |

> **Note syntaxe Make** : `?=` (affectation conditionnelle) permet l'override CLI (`make target KEY=val`).

### Script de génération

`scripts/config-init.sh` opère en deux étapes :

**Étape 1 — Initialisation idempotente** (mode `make config` seulement)
```
.env.example      --[si .env absent]--> .env
.env.user.example --[si .env.user absent]--> .env.user
```

**Étape 2 — Fusion et génération** (toujours exécutée)
```
config/*.example.env ]
.env                 ]--> [Python3 merge] --> MERGED
.env.user            ]
                              |
              ┌───────────────┼──────────────┐
              v               v              v
          env.sh        env.docker        env.mk
```

La fusion est réalisée par un script Python3 embarqué (inline) sans dépendance externe.

### Variables types pour private-llm-gateway

**`config/azure-proxy.example.env` (publiques, versionées)** :
```bash
# Proxy Azure HTTPS
AZURE_PROXY_RESOURCE_GROUP=rg-llm-gateway
AZURE_PROXY_SUBSCRIPTION_ID=
AZURE_PROXY_LOCATION=westeurope
PROXY_DOMAIN=llm.example.com

# Azure Relay Hybrid Connection
AZURE_RELAY_NAMESPACE=relay-llm-prod
AZURE_RELAY_HYBRID_CONNECTION=llm-gateway-hc
AZURE_RELAY_RESOURCE_GROUP=rg-llm-gateway
```

**`config/local-agent.example.env` (publiques, versionées)** :
```bash
# Agent local (relay_agent.py)
LOCAL_AGENT_PORT=5000
LOCAL_AGENT_TARGET=http://127.0.0.1:4000

# LiteLLM
LITELLM_HOST=0.0.0.0
LITELLM_PORT=4000
LITELLM_CONFIG_PATH=config/litellm.example.yaml

# Ollama
OLLAMA_HOST=http://localhost:11434
OLLAMA_DEFAULT_MODEL=qwen2.5:7b

# Logging
LOG_LEVEL=INFO
LOG_FORMAT=json
```

**`.env.user` (secrets, NON versionés)** :
```bash
# Azure Relay connection string (secret critique)
AZURE_RELAY_CONNECTION_STRING=Endpoint=sb://....servicebus.windows.net/;...

# Clés optionnelles
AZURE_SUBSCRIPTION_ID=
LITELLM_API_KEY=
```

### Commandes principales

```bash
# Setup initial (idempotent)
make config             # Init .env / .env.user (si absents) + génère config/generated/
make config-generate    # Régénérer config/generated/ uniquement (sans toucher .env)

# Utilisation dans scripts Bash
source config/generated/env.sh && ./scripts/start-local-agent.sh

# Utilisation dans Makefile
include config/generated/env.mk
```

### ⚠️ Règles Critiques

1. **NE JAMAIS éditer** `config/generated/*` manuellement
2. **TOUJOURS** passer par `config/*.example.env`, `.env` ou `.env.user`
3. **TOUJOURS** régénérer avec `make config-generate` après modification
4. **NE JAMAIS** commiter `config/generated/*` dans Git (dans `.gitignore`)
5. **NE JAMAIS** commiter `.env.user` dans Git (contient secrets/clés privés)

## 📊 Matrice de Décision Quantifiée

| Critère | Poids | Architecture initiale (envs séparés) | Variables système | Architecture retenue (3 couches + config-init.sh) |
|---------|-------|--------------------------------------|--------------------|----------------------------------------------------|
| **Sécurité** | 30% | 7/10 | 6/10 | **9/10** |
| **Maintenabilité** | 25% | 6/10 | 4/10 | **9/10** |
| **Compatibilité multi-runtime** | 20% | 6/10 | 7/10 | **10/10** |
| **Simplicité setup** | 15% | 7/10 | 4/10 | **9/10** |
| **Portabilité (sans deps)** | 10% | 5/10 | 8/10 | **9/10** |
| **Score Total** | | **6.65** | **5.55** | **9.30** ⭐ |

## ⚖️ Conséquences

### ✅ Positives

| Bénéfice | Impact | Métrique |
|----------|--------|----------|
| **Zéro secret versioné** | Critique | `.env.user` dans `.gitignore` |
| **4 formats synchronisés** | Élevé | Un seul `make config-generate` suffit |
| **Override CLI Make** | Moyen | Syntaxe `?=` dans `env.mk` |
| **Pas de dépendance Python externe** | Moyen | Python3 stdlib uniquement |
| **Init idempotente** | Moyen | `make config` safe à rejouer |

### ⚠️ Négatives & Mitigations

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| Oubli de `make config-generate` après édition de `.env` | Moyenne | Faible | Ajouter comme prérequis de `agent-start` si besoin |
| Secret committé par erreur dans `.env` | Faible | Critique | `.gitignore` strict ; `.env.example` ne contient aucune valeur secrète |
| `config/generated/` committé par erreur | Faible | Moyen | `config/generated/*` dans `.gitignore` (sauf `.gitkeep`) |

## 🔄 Alternatives Considérées

### Alternative 1 : SOPS / git-crypt (secrets versionés chiffrés)

**Avantages** : Secrets partagés entre contributeurs via Git
**Inconvénients** : Outillage supplémentaire (clé GPG / age), friction onboarding
**Rejeté** : Projet mono-machine local, coût disproportionné

### Alternative 2 : Variables d'environnement système uniquement

**Avantages** : Aucun fichier à gérer
**Inconvénients** : Pas de versionning des défauts, setup complexe multi-projets
**Rejeté** : Maintenabilité insuffisante

## 🚀 Plan d'Implémentation

| Phase | Actions | Statut |
|-------|---------|--------|
| **1. Templates** | `.env.example`, `.env.user.example` créés | ✅ Fait |
| **2. Script** | `scripts/config-init.sh` (Python3 inline, 4 formats) | 🔄 À faire |
| **3. Makefile** | Cibles `config` et `config-generate` | 🔄 À faire |
| **4. .gitignore** | `config/generated/*` + `!config/generated/.gitkeep` + `.env.user` | ✅ Fait |

## 🎯 Critères de Succès

| Critère | Cible | Résultat |
|---------|-------|----------|
| Secrets dans Git | 0 | 🔄 `.env.user` à ajouter au .gitignore |
| Formats générés | 3 | 🔄 env.sh, env.docker, env.mk à générer |
| Commande d'init | 1 commande | 🔄 `make config` à implémenter |
| Temps setup nouveau contributeur | < 5 min | 🎯 Objectif |

## 🔗 Traçabilité & Liens

### ADRs Connexes
- [ADR-200](./200-INFRA-conteneurisation-services-docker.md) - Docker Compose potentiel ; consomme `config/generated/env.docker` via `--env-file`
- [ADR-601](./601-DEVOPS-nomenclature-scripts.md) - Nomenclature scripts ; `config-init.sh` suit la convention `{objet}-{action}.sh`
- [ADR-602](./602-DEVOPS-makefile-orchestrateur.md) - Makefile orchestrateur ; expose `make config` et `make config-generate`

### Fichiers Impactés
```
config/
├── azure-proxy.example.env        # Template Azure proxy
├── local-agent.example.env        # Template agent local
├── litellm.example.yaml           # Config LiteLLM
└── generated/                     # Répertoire de sortie
    ├── .gitkeep
    ├── env.sh
    ├── env.docker
    └── env.mk
scripts/
└── config-init.sh                 # Script de génération (à créer)
.env.example                       # Template versioné
.env.user.example                  # Template secrets versioné (à créer)
.env                               # Surcharges locales (racine)
.env.user                          # Secrets locaux (non versioné)
.gitignore                         # Mis à jour
Makefile                           # Cibles config / config-generate (à créer)
```

---

**Projet**: private-llm-gateway  
**Repo**: https://github.com/michel-heon/private-llm-gateway  
**Date**: 2026-06-05
