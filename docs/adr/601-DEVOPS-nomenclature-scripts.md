---
adr: 601
title: "Nomenclature des Scripts et Règles Makefile"
status: "accepted"
date: 2026-06-05
classification:
  lifecycle: "accepted"
  domain: "devops"
  impact: "low"
  quality: ["maintainability", "discoverability"]
  reversibility: "easy"
  scope: "tactical"
  tech_areas: ["bash", "makefile", "python"]
tags: ["devops", "scripting", "bash", "makefile", "naming", "python"]
stakeholders: ["@devops-team", "@dev-team"]
effort: "low"
related_issues: []
related_adrs: [602, 600, 607]
replaces: null
superseded_by: null
---

# ADR 601: Nomenclature des Scripts et Règles Makefile

## 📋 Vue d'Ensemble

| Attribut | Valeur |
|----------|--------|
| **Statut** | ✅ Accepté |
| **Date décision** | 2026-06-05 |
| **Impact** | 🟢 Faible (conventions scripts) |
| **Domaine** | DevOps |
| **Réversibilité** | 🟢 Élevée (renommage scripts) |
| **Portée** | Projet complet |

## 🎯 Contexte

Le projet **private-llm-gateway** comprend des scripts d'automatisation pour :
- **Configuration et vérification** : endpoints locaux et publics, configuration Azure
- **Démarrage services** : Ollama, LiteLLM, agent local (relay_agent.py)
- **Infrastructure Azure** : Azure Relay, proxy HTTPS, DNS
- **Tests et validation** : endpoints health, intégration gateway

Sans convention de nommage claire :
- **Difficulté de découverte** : Les développeurs ne trouvent pas le script voulu
- **Inconsistance** : Styles mélangés (`deploy.sh`, `setupRelay.sh`, `check_endpoint.sh`)
- **Maintenance complexe** : Difficile de comprendre rapidement la fonction d'un script

## Décision

Adopter une nomenclature standardisée pour **tous les scripts d'automatisation** (Bash/Python) et **règles Makefile** selon le format :

```
{object}-{action}.{ext}
```

### Règles de Nomenclature

1. **Format obligatoire** : `{object}-{action}.{ext}`
   - `{object}` : Composant/domaine concerné (nom singulier ou composé)
   - `{action}` : Action effectuée (verbe infinitif)
   - Séparateur : tiret (`-`)
   - Extension : `.sh` (Bash), `.py` (Python)

2. **Conventions**
   - **Tout en minuscules** (lowercase)
   - **Mots séparés par des tirets**
   - **Objet au singulier** : `ollama`, `litellm`, `agent`, `endpoint`, `relay`, `proxy`, `config`
   - **Action en verbe** : `start`, `stop`, `check`, `configure`, `install`, `validate`, `test`

3. **Exemples valides**

   **Scripts cibles (pattern `{object}-{action}`)** :
   ```
   ollama-start.sh              # Démarrage Ollama
   litellm-start.sh             # Démarrage LiteLLM
   local-agent-start.sh         # Démarrage agent local (relay_agent.py)
   local-endpoint-check.sh      # Vérification endpoint local
   public-endpoint-check.sh     # Vérification endpoint public
   ```

   **Scripts actuels (à renommer - RECIT-203)** :
   ```bash
   start-ollama.sh              # ❌ Pattern {action}-{object}
   start-litellm.sh             # ❌ Pattern {action}-{object}
   start-local-agent.sh         # ❌ Pattern {action}-{object}
   check-local-endpoint.sh      # ❌ Pattern {action}-{object}
   check-public-endpoint.sh     # ❌ Pattern {action}-{object}
   ```

   **Scripts à créer (infrastructure Azure)** :
   ```
   relay-configure.sh           # Configuration Azure Relay Hybrid Connection
   relay-validate.sh            # Validation connection string et connectivité
   proxy-deploy.sh              # Déploiement proxy HTTPS Azure
   proxy-configure.sh           # Configuration Caddy/Nginx sur Azure
   dns-configure.sh             # Configuration DNS (GoDaddy ou autre)
   gateway-test.sh              # Tests end-to-end du gateway complet
   ```

   **Scripts configuration et setup** :
   ```
   config-init.sh               # Initialisation configuration (.env)
   config-generate.sh           # Génération formats config (env.sh, env.docker, env.mk)
   environment-setup.sh         # Setup environnement complet (Python venv, deps)
   ```

4. **Convention spéciale: Composants multi-mots**

   Pour scripts qui gèrent des composants à nom composé :

   **Format** : `{composant}-{action}.sh`

   ```bash
   # Composant-action cohérent
   local-agent-start.sh           # Démarrage agent local (relay_agent.py)
   local-agent-stop.sh            # Arrêt agent local
   azure-relay-configure.sh       # Configuration Azure Relay
   hybrid-connection-test.sh      # Test Hybrid Connection
   https-proxy-deploy.sh          # Déploiement proxy HTTPS
   ```

5. **Règles Makefile**

   Les targets Makefile suivent une convention similaire **sans extension** :

   **Format général** : `{object}-{action}` ou `{action}` (verbe seul pour targets standards)

   ```makefile
   # Targets standards (exemptions)
   help, setup, clean, test, deploy, validate

   # Targets composants (object-action)
   ollama-start           # Démarre Ollama
   ollama-stop            # Arrête Ollama
   litellm-start          # Démarre LiteLLM
   agent-start            # Démarre agent local (relay_agent.py)
   agent-stop             # Arrête agent local
   endpoint-check         # Vérifie endpoints (local + public)
   relay-configure        # Configure Azure Relay
   proxy-deploy           # Déploie proxy HTTPS Azure
   gateway-test           # Tests end-to-end
   ```

6. **Organisation dans `scripts/`**

   **Structure cible (après RECIT-203)** :
   ```
   scripts/
   ├── README.md                          # Documentation des scripts
   │
   ├── # Services locaux
   ├── ollama-start.sh                    # Démarrage Ollama
   ├── litellm-start.sh                   # Démarrage LiteLLM
   ├── local-agent-start.sh               # Démarrage agent local (relay_agent.py)
   │
   ├── # Vérifications
   ├── local-endpoint-check.sh            # Vérification endpoint local
   ├── public-endpoint-check.sh           # Vérification endpoint public
   │
   ├── # Configuration
   ├── config-init.sh                     # Initialisation configuration
   ├── config-generate.sh                 # Génération formats config
   │
   ├── # Infrastructure Azure (à créer)
   ├── relay-configure.sh                 # Configuration Azure Relay
   ├── relay-validate.sh                  # Validation Azure Relay
   ├── proxy-deploy.sh                    # Déploiement proxy HTTPS
   ├── proxy-configure.sh                 # Configuration Caddy/Nginx
   └── gateway-test.sh                    # Tests end-to-end gateway
   ```

   **Structure actuelle (avant RECIT-203)** :
   ```
   scripts/
   ├── start-ollama.sh                    # ❌ À renommer → ollama-start.sh
   ├── start-litellm.sh                   # ❌ À renommer → litellm-start.sh
   ├── start-local-agent.sh               # ❌ À renommer → local-agent-start.sh
   ├── check-local-endpoint.sh            # ❌ À renommer → local-endpoint-check.sh
   └── check-public-endpoint.sh           # ❌ À renommer → public-endpoint-check.sh
   ```

### Exemples de Migration

**Avant (❌ non-conforme ADR-601) :**
```bash
# Scripts actuels à renommer (RECIT-203)
scripts/start-ollama.sh          # {action}-{object}
scripts/start-litellm.sh         # {action}-{object}
scripts/start-local-agent.sh     # {action}-{object}
scripts/check-local-endpoint.sh  # {action}-{object}
scripts/check-public-endpoint.sh # {action}-{object}

# Autres patterns non-standard
scripts/setupRelay.sh            # camelCase
scripts/start_agent.sh           # underscore
scripts/CheckEndpoint.sh         # Majuscule
scripts/deploy.sh                # Nom générique
```

**Après (✅ conforme ADR-601) :**
```bash
# Pattern {object}-{action} standard
scripts/ollama-start.sh              # objet-action, lowercase
scripts/litellm-start.sh             # objet-action, lowercase
scripts/local-agent-start.sh         # objet-action, lowercase
scripts/local-endpoint-check.sh      # objet-action, lowercase
scripts/public-endpoint-check.sh     # objet-action, lowercase

# Nouveaux scripts infrastructure
scripts/relay-configure.sh           # objet-action, lowercase
scripts/agent-start.sh               # tirets
scripts/endpoint-check.sh            # lowercase
scripts/proxy-deploy.sh              # objet-action
scripts/gateway-test.sh              # composant-action
```

## Conséquences

### Positives ✅

- **Prévisibilité** : Le nom révèle immédiatement le composant et l'action
- **Découvrabilité** : `ls scripts/agent-*` liste tous les scripts agent ; `ls scripts/relay-*` tous les scripts relay
- **Cohérence** : Pattern uniforme Bash + Python + Makefile
- **Auto-complétion** : `ollama-<TAB>` liste les scripts Ollama
- **Lisibilité** : Noms harmonieux avec l'architecture du projet

### Négatives ⚠️

- **Migration** : Scripts existants à renommer si nécessaire
- **Discipline** : Nécessite rigueur sur la durée

## Alternatives Considérées

### Object-Action (`ollama-start.sh`) 
**✅ Retenue** : Pattern choisi pour découvrabilité et cohérence
- `ls scripts/ollama-*` liste tous les scripts Ollama
- `ls scripts/relay-*` liste tous les scripts relay
- Regroupement naturel par composant
- Cohérence avec nomenclature des targets Makefile

### Action-Object (`start-ollama.sh`)
**❌ Rejetée** : Pattern actuel des scripts existants, mais moins découvrable
- Plus naturel en langage naturel ("start ollama")
- Mais difficile de lister tous les scripts d'un composant
- Nécessite renommage des scripts existants

### CamelCase (`ollamaStart.sh`)
**❌ Rejetée** : Non-conforme conventions Unix/Linux

### Underscore (`ollama_start.sh`)
**❌ Rejetée** : Tirets préférés dans l'écosystème Linux moderne

## 🚀 Plan d'Implémentation

- [x] Définir et documenter la convention (cet ADR)
- [ ] Renommer scripts existants selon pattern `{object}-{action}` (RECIT-203)
- [ ] Créer `scripts/README.md` avec liste des scripts disponibles
- [ ] Vérification convention dans code review PR

## 🔗 Traçabilité & Liens

- [ADR-600](./600-DEVOPS-bootstrap-configuration-management.md) - Configuration bootstrap
- [ADR-602](./602-DEVOPS-makefile-orchestrateur.md) - Makefile orchestrateur
- [ADR-607](./607-DEVOPS-gestion-options-scripts-bash.md) - Options scripts Bash

## 📝 Notes & Historique

| Date | Auteur | Changement | Raison |
|------|--------|------------|--------|
| 2026-06-05 | @dev-team | Création ADR-601 | Mise en place conventions scripts private-llm-gateway |

---

**Projet**: private-llm-gateway  
**Repo**: https://github.com/michel-heon/private-llm-gateway  
**Date**: 2026-06-05
