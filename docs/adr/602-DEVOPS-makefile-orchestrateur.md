---
adr: 602
title: "Makefile comme Orchestrateur de Scripts"
status: "accepted"
date: 2026-06-05
classification:
  lifecycle: "accepted"
  domain: "devops"
  impact: "medium"
  quality: ["maintainability", "usability"]
  reversibility: "moderate"
  scope: "tactical"
  tech_areas: ["bash", "makefile", "python"]
tags: ["makefile", "orchestration", "automation", "devops", "python"]
stakeholders: ["@devops-team", "@dev-team"]
effort: "low"
related_issues: []
related_adrs: [200, 600, 601, 605, 607]
replaces: null
superseded_by: null
---

# ADR 602: Makefile comme Orchestrateur de Scripts

## 📋 Vue d'Ensemble

| Attribut | Valeur |
|----------|--------|
| **Statut** | ✅ Accepté |
| **Date décision** | 2026-06-05 |
| **Impact** | 🟡 Moyen (workflow développeur) |
| **Domaine** | DevOps |
| **Réversibilité** | 🟡 Modérée |
| **Portée** | Projet complet |

## 🎯 Contexte

Le projet **private-llm-gateway** comprend plusieurs types d'opérations distinctes :
- **Services locaux** : démarrage Ollama, LiteLLM, agent local (relay_agent.py)
- **Infrastructure Azure** : configuration Azure Relay, déploiement proxy HTTPS, configuration DNS
- **Tests et validation** : vérification endpoints locaux/publics, tests end-to-end gateway
- **Configuration** : génération multi-format configuration, initialisation environnement

**Problèmes sans orchestration** :
- Développeurs doivent mémoriser les noms exacts et les arguments de chaque script
- Dépendances entre scripts non documentées (ex: `config` avant `agent-start`)
- Pas de guide unifié pour découvrir les commandes disponibles
- Courbe d'apprentissage élevée pour nouveaux contributeurs

## 💡 Décision

**Nous adoptons Makefile comme couche d'orchestration standard pour l'ensemble du projet.**

Le Makefile racine :
- **Expose une interface simple** : `make <commande>` au lieu de `./scripts/nom-complexe.sh --arg1`
- **Documente automatiquement** : `make help` affiche toutes les commandes disponibles
- **Valide les prérequis** : Vérifie configuration avant exécution
- **Chaîne les dépendances** : `make agent-start` s'assure que `config` et `ollama-start` sont exécutés avant

### Structure Standard du Makefile

```makefile
# Makefile - private-llm-gateway
# Orchestration gateway HTTPS sécurisé pour LLMs locaux

.PHONY: help setup config clean \
        ollama-start ollama-stop \
        litellm-start litellm-stop \
        agent-start agent-stop \
        endpoint-check relay-configure \
        proxy-deploy gateway-test

# Variables
SCRIPTS_DIR   := scripts
ENV_GENERATED := config/generated/env.mk
LITELLM_HOST  := 0.0.0.0
LITELLM_PORT  := 4000
OLLAMA_HOST   := http://localhost:11434
AGENT_PORT    := 5000

# Couleurs
BLUE  := \033[0;34m
GREEN := \033[0;32m
YELLOW:= \033[1;33m
RED   := \033[0;31m
NC    := \033[0m

# Inclure variables générées (après make config)
-include $(ENV_GENERATED)

##@ Aide

help: ## Afficher cette aide
	@printf "$(BLUE)══════════════════════════════════════════════════════$(NC)\n"
	@printf "$(GREEN)  private-llm-gateway — Gateway HTTPS Sécurisé         $(NC)\n"
	@printf "$(BLUE)══════════════════════════════════════════════════════$(NC)\n"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(GREEN)%-25s$(NC) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

##@ Configuration & Setup

setup: config ollama-start litellm-start ## Setup complet de l'environnement local

config: ## Initialise .env / .env.user (idempotent) + génère config/generated/
	@$(SCRIPTS_DIR)/config-init.sh
	@printf "$(GREEN)✅ Fichiers générés dans config/generated/$(NC)\n"

config-generate: ## Régénère config/generated/ sans toucher .env
	@$(SCRIPTS_DIR)/config-init.sh --generate-only

check-env: ## Vérifier que la configuration est présente
	@if [ ! -f "$(ENV_GENERATED)" ]; then \
		printf "$(RED)❌ Configuration manquante. Exécuter: make config$(NC)\n"; \
		exit 1; \
	fi

clean: ## Nettoyer fichiers générés et temporaires
	@rm -rf config/generated/
	@printf "$(GREEN)✅ Nettoyage effectué$(NC)\n"

##@ Services Locaux

ollama-start: ## Démarrer Ollama
	@$(SCRIPTS_DIR)/start-ollama.sh

ollama-stop: ## Arrêter Ollama
	@pkill -f ollama || true

litellm-start: check-env ## Démarrer LiteLLM (gateway OpenAI-compatible)
	@$(SCRIPTS_DIR)/start-litellm.sh

litellm-stop: ## Arrêter LiteLLM
	@pkill -f litellm || true

agent-start: check-env ollama-start litellm-start ## Démarrer agent local (relay_agent.py)
	@$(SCRIPTS_DIR)/start-local-agent.sh

agent-stop: ## Arrêter agent local
	@pkill -f relay_agent.py || true

##@ Tests & Validation

endpoint-check: ## Vérifier endpoints local et public
	@$(SCRIPTS_DIR)/check-local-endpoint.sh
	@$(SCRIPTS_DIR)/check-public-endpoint.sh

gateway-test: check-env ## Tests end-to-end du gateway complet
	@$(SCRIPTS_DIR)/gateway-test.sh

##@ Infrastructure Azure

relay-configure: check-env ## Configurer Azure Relay Hybrid Connection
	@$(SCRIPTS_DIR)/relay-configure.sh

relay-validate: check-env ## Valider connection Azure Relay
	@$(SCRIPTS_DIR)/relay-validate.sh

proxy-deploy: check-env ## Déployer proxy HTTPS Azure
	@$(SCRIPTS_DIR)/proxy-deploy.sh

proxy-configure: check-env ## Configurer Caddy/Nginx sur Azure
	@$(SCRIPTS_DIR)/proxy-configure.sh

dns-configure: ## Configurer DNS (GoDaddy ou autre)
	@$(SCRIPTS_DIR)/dns-configure.sh
```

### Hiérarchie des règles

1. **Workflows réutilisables** (setup, start, test, deploy) → **doivent** passer par `make`
2. **Logique métier** → **doit** être dans un script `scripts/*.sh` ou `*.py`, appelé par `make`
3. **One-shot** (debug ponctuel) → peut être exécuté directement, mais ne doit pas devenir une procédure implicite

### Règle de séparation : Makefile vs Scripts

**Principe fondamental** : Le Makefile est un **orchestrateur**, pas un processeur de logique.

**Règle des 3 lignes** : Si une target nécessite plus de 3 lignes de logique (boucles, conditions complexes, transformations), extraire dans un script dédié.

**Ce qui reste dans Makefile** :
```makefile
agent-start: check-env ollama-start litellm-start  ## Démarrer agent local
	@printf "$(BLUE)Démarrage agent local...$(NC)\n"
	@$(SCRIPTS_DIR)/start-local-agent.sh
```

**Ce qui va dans `scripts/`** :
- Logique de validation complexe (vérifications multi-étapes)
- Appels API avec gestion d'erreurs et retries
- Parsings et transformations
- Configuration Azure Relay (connection strings, credentials)

**Anti-pattern (logique dans Makefile)** :
```makefile
# ❌ MAUVAIS: Logique métier inline
relay-configure:
	@if [ -z "$(AZURE_RELAY_CONNECTION_STRING)" ]; then \
		echo "Connection string manquante"; \
		exit 1; \
	fi
	@az relay hyco create ...
```

**Pattern correct** :
```makefile
# ✅ BON: Orchestrateur → script
relay-configure: check-env ## Configurer Azure Relay
	@$(SCRIPTS_DIR)/relay-configure.sh
```

### Commandes standardisées (obligatoires)

Chaque projet/sous-répertoire avec Makefile doit implémenter :
- `make help` — Aide formatée
- `make setup` — Configuration initiale
- `make clean` — Nettoyage
- `make test` — Tests

## ⚖️ Conséquences

### ✅ Positives

| Bénéfice | Métrique |
|----------|----------|
| **Découvrabilité** | `make help` liste toutes les commandes |
| **Builds reproductibles** | Commande identique = résultat identique |
| **Onboarding rapide** | Nouveau contributeur opérationnel en < 15 min |
| **Validation prérequis** | Zéro échec pour config manquante |
| **Dépendances explicites** | `agent-start` démarre automatiquement Ollama et LiteLLM |

### ⚠️ Négatives & Mitigations

| Risque | Mitigation |
|--------|------------|
| Makefile complexe | Règle 3 lignes → scripts dédiés |
| Dépendance GNU Make | Disponible nativement Linux/macOS, WSL2 sur Windows |

## 🔄 Alternatives Considérées

### Just (task runner moderne)
**Avantages** : Syntaxe plus lisible que Make  
**Rejeté** : Installation supplémentaire, pas natif, communauté plus petite

### Scripts shell d'orchestration (`run.sh`)
**Rejeté** : Pas d'aide automatique, gestion dépendances manuelle, moins standard

## 🔗 Traçabilité & Liens

- [ADR-600](./600-DEVOPS-bootstrap-configuration-management.md) - Gestion multi-format des variables de configuration
- [ADR-601](./601-DEVOPS-nomenclature-scripts.md) - Nomenclature scripts
- [ADR-605](./605-DEVOPS-gestion-couleurs-scripts-make.md) - Couleurs ANSI dans Make (`printf`)
- [ADR-607](./607-DEVOPS-gestion-options-scripts-bash.md) - Options scripts Bash

## 📝 Notes & Historique

| Date | Auteur | Changement | Raison |
|------|--------|------------|--------|
| 2026-06-05 | @dev-team | Création ADR-602 | Mise en place Makefile orchestrateur private-llm-gateway |

---

**Projet**: private-llm-gateway  
**Repo**: https://github.com/michel-heon/private-llm-gateway  
**Date**: 2026-06-05
