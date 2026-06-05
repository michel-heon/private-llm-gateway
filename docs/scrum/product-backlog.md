# Product Backlog — Private LLM Gateway

Product Backlog combinant **Epics** et **User Stories** pour le projet Private LLM Gateway.  
Priorisation selon méthode **MoSCoW** (Must, Should, Could, Won't).

---

## 📊 Vue d'Ensemble

| Métrique | Valeur |
|----------|--------|
| **Total Epics** | 5 |
| **Total User Stories** | 23 |
| **Must Have** | 12 stories |
| **Should Have** | 7 stories |
| **Could Have** | 4 stories |

**Prochains sprints planifiés** :
- **Sprint 1** (2026-06-05 → 2026-06-19) : Epic 1 (macMLX) + Epic 2 (DevOps) 
- **Sprint 2** (2026-06-20 → 2026-07-03) : Epic 3 (Sécurité)
- **Sprint 3** (2026-07-04 → 2026-07-17) : Epic 4 (IaC) + Epic 5 (Monitoring)

---

## 🎯 Epic 1 : Support macMLX Complet

**Objectif** : Offrir macMLX comme alternative performante à Ollama sur Apple Silicon  
**Personas** : Alex (Développeur), Sam (Utilisateur)  
**Valeur Métier** : 2x speedup pour les utilisateurs Mac M1/M2/M3/M4  
**Statut** : 🟢 En cours

### User Stories

#### US-101 : Documenter installation et configuration macMLX
**En tant que** développeur sur Mac Apple Silicon  
**Je veux** une documentation claire pour installer macMLX  
**Afin de** remplacer Ollama par une solution 2x plus rapide

**Acceptance Criteria** :
- [ ] Guide installation macMLX dans `docs/guides/setup/litellm-ollama.md` ✅ FAIT
- [ ] Comparaison Ollama vs macMLX (tableau performance) ✅ FAIT
- [ ] Configuration LiteLLM pour port 8080 ✅ FAIT
- [ ] Benchmark M2 Max documenté ✅ FAIT

**Priorité** : Must Have  
**Effort** : 2 points  
**Sprint** : Sprint 1  
**Statut** : ✅ **Complété** (2026-06-05)

---

#### US-102 : Créer script de démarrage macMLX
**En tant que** développeur  
**Je veux** un script shell pour démarrer macMLX facilement  
**Afin de** éviter de mémoriser les commandes CLI

**Acceptance Criteria** :
- [ ] Script `scripts/start-macmlx.sh` créé
- [ ] Supporte options `--model`, `--port`, `--verbose`
- [ ] Gère les erreurs (macMLX non installé, port occupé)
- [ ] Suit la nomenclature ADR-601 (`{object}-{action}.sh`)

**Priorité** : Must Have  
**Effort** : 3 points  
**Sprint** : Sprint 1  
**Statut** : 📋 To Do

---

#### US-103 : Ajouter cible Makefile pour macMLX
**En tant que** développeur  
**Je veux** une commande `make macmlx-start`  
**Afin de** unifier le lancement avec les autres services

**Acceptance Criteria** :
- [ ] Cible `macmlx-start` dans Makefile
- [ ] Cible `macmlx-stop` pour arrêter proprement
- [ ] Cible `macmlx-status` pour vérifier l'état
- [ ] Respecte ADR-602 (Makefile orchestrateur)

**Priorité** : Should Have  
**Effort** : 2 points  
**Sprint** : Sprint 1  
**Statut** : 📋 To Do

---

#### US-104 : Adapter configuration LiteLLM pour dual runtime
**En tant que** développeur  
**Je veux** pouvoir switcher facilement entre Ollama et macMLX  
**Afin de** comparer les performances ou utiliser selon le contexte

**Acceptance Criteria** :
- [ ] Variable d'environnement `LLM_RUNTIME=ollama|macmlx`
- [ ] LiteLLM route vers le bon port (11434 ou 8080)
- [ ] Configuration yaml adaptative (config/litellm.yaml)
- [ ] Documentation du switch dans README

**Priorité** : Could Have  
**Effort** : 5 points  
**Sprint** : Sprint 2  
**Statut** : 📋 To Do

---

## 🛠️ Epic 2 : Implémentation Patterns DevOps (ADR 600-607)

**Objectif** : Automatiser la gestion de config, scripts et Makefile  
**Personas** : Alex (Développeur), Jordan (DevOps)  
**Valeur Métier** : Réduction de 60% du temps de setup  
**Statut** : 📋 To Do

### User Stories

#### US-201 : Implémenter bootstrap configuration multi-format
**En tant que** développeur  
**Je veux** un système de configuration 3 couches (.env → .env.user → formats générés)  
**Afin de** éviter les conflits entre environnements

**Acceptance Criteria** :
- [ ] Script `scripts/config-bootstrap.sh` créé
- [ ] Génère `env.sh`, `env.docker`, `env.mk` depuis .env
- [ ] Respecte ADR-600 (configuration management)
- [ ] Tests de génération avec différents .env

**Priorité** : Must Have  
**Effort** : 8 points  
**Sprint** : Sprint 1  
**Statut** : 📋 To Do

---

#### US-202 : Créer Makefile orchestrateur principal
**En tant que** développeur  
**Je veux** un Makefile avec cibles standardisées  
**Afin de** lancer tous les composants uniformément

**Acceptance Criteria** :
- [ ] Makefile avec cibles : `setup`, `config`, `start`, `stop`, `test`, `clean`
- [ ] Respecte ADR-602 (règle des 3 lignes)
- [ ] Gère les dépendances entre cibles (ex: `start` nécessite `config`)
- [ ] Aide intégrée `make help`

**Priorité** : Must Have  
**Effort** : 8 points  
**Sprint** : Sprint 1  
**Statut** : 📋 To Do

---

#### US-203 : Standardiser nomenclature scripts existants
**En tant que** développeur  
**Je veux** renommer les scripts selon ADR-601  
**Afin de** avoir une cohérence `{object}-{action}.sh`

**Acceptance Criteria** :
- [ ] Audit des scripts actuels (`scripts/`)
- [ ] Renommage selon pattern (ex: `start-ollama.sh` → `ollama-start.sh`)
- [ ] Mise à jour des références dans Makefile et docs
- [ ] Tests après renommage

**Priorité** : Should Have  
**Effort** : 3 points  
**Sprint** : Sprint 1  
**Statut** : 📋 To Do

---

#### US-204 : Ajouter couleurs ANSI aux scripts
**En tant que** développeur  
**Je veux** des logs colorés dans les scripts bash  
**Afin de** identifier rapidement les erreurs/succès

**Acceptance Criteria** :
- [ ] Macros printf dans Makefile (ADR-605)
- [ ] Fonctions bash `log_info`, `log_success`, `log_error`
- [ ] Couleurs appliquées à tous les scripts
- [ ] Compatible macOS et Linux

**Priorité** : Should Have  
**Effort** : 3 points  
**Sprint** : Sprint 2  
**Statut** : 📋 To Do

---

#### US-205 : Implémenter parsing d'options Bash standard
**En tant que** développeur  
**Je veux** que tous les scripts supportent `-h/--help`, `-v/--verbose`  
**Afin de** avoir une interface utilisateur cohérente

**Acceptance Criteria** :
- [ ] Pattern while/case/shift dans tous les scripts (ADR-607)
- [ ] Options standard : `-h`, `-v`, `-n` (dry-run), `-o` (output)
- [ ] Fonction `_usage()` obligatoire
- [ ] Tests des options pour chaque script

**Priorité** : Should Have  
**Effort** : 5 points  
**Sprint** : Sprint 2  
**Statut** : 📋 To Do

---

## 🔐 Epic 3 : Security Hardening

**Objectif** : Sécuriser le gateway selon docs/reference/security.md  
**Personas** : Riley (Security), Jordan (DevOps)  
**Valeur Métier** : Réduction des risques d'exposition/breach  
**Statut** : 📋 To Do

### User Stories

#### US-301 : Intégrer Azure Key Vault pour secrets
**En tant que** DevOps engineer  
**Je veux** stocker les secrets dans Azure Key Vault  
**Afin de** ne jamais commiter de credentials dans le code

**Acceptance Criteria** :
- [ ] Provisionner Key Vault via script ou IaC
- [ ] Stocker `AZURE_RELAY_CONNECTION_STRING` dans Key Vault
- [ ] Agent relay récupère secrets via Managed Identity
- [ ] Documentation rotation des secrets

**Priorité** : Must Have  
**Effort** : 8 points  
**Sprint** : Sprint 2  
**Statut** : 📋 To Do

---

#### US-302 : Implémenter log redaction
**En tant que** security engineer  
**Je veux** que les prompts et API keys soient masqués dans les logs  
**Afin de** éviter les fuites de données sensibles

**Acceptance Criteria** :
- [ ] Fonction Python `redact_sensitive_data()` dans relay_agent.py
- [ ] Patterns regex pour API keys, connection strings
- [ ] Logs structurés (JSON) avec champ `redacted: true`
- [ ] Tests unitaires de redaction

**Priorité** : Must Have  
**Effort** : 5 points  
**Sprint** : Sprint 2  
**Statut** : 📋 To Do

---

#### US-303 : Ajouter rate limiting au proxy Azure
**En tant que** DevOps engineer  
**Je veux** limiter les requêtes par IP/utilisateur  
**Afin de** éviter les abus et contrôler les coûts

**Acceptance Criteria** :
- [ ] Configuration rate limit (ex: 100 req/min/IP)
- [ ] Réponse HTTP 429 avec Retry-After header
- [ ] Métriques de throttling dans Application Insights
- [ ] Documentation des limites dans README

**Priorité** : Must Have  
**Effort** : 5 points  
**Sprint** : Sprint 2  
**Statut** : 📋 To Do

---

#### US-304 : Créer threat model diagram
**En tant que** security engineer  
**Je veux** un diagramme d'architecture avec attack surface  
**Afin de** identifier les vecteurs d'attaque potentiels

**Acceptance Criteria** :
- [ ] Diagramme threat model (Mermaid ou draw.io)
- [ ] Trust boundaries identifiées
- [ ] STRIDE analysis pour chaque composant
- [ ] Mitigations documentées dans `docs/reference/security.md`

**Priorité** : Should Have  
**Effort** : 5 points  
**Sprint** : Sprint 3  
**Statut** : 📋 To Do

---

## ☁️ Epic 4 : Infrastructure as Code (IaC)

**Objectif** : Automatiser le déploiement Azure avec Bicep/Terraform  
**Personas** : Jordan (DevOps)  
**Valeur Métier** : Déploiement reproductible en <30min  
**Statut** : 📋 To Do

### User Stories

#### US-401 : Créer template Bicep pour Azure Relay
**En tant que** DevOps engineer  
**Je veux** un template Bicep pour provisionner Relay namespace + Hybrid Connection  
**Afin de** automatiser le déploiement Azure

**Acceptance Criteria** :
- [ ] Fichier `infra/bicep/relay.bicep`
- [ ] Paramètres : location, sku, connection name
- [ ] Output : connection string (secured)
- [ ] Tests de déploiement sur subscription test

**Priorité** : Must Have  
**Effort** : 8 points  
**Sprint** : Sprint 3  
**Statut** : 📋 To Do

---

#### US-402 : Créer template Bicep pour HTTPS proxy
**En tant que** DevOps engineer  
**Je veux** un template Bicep pour App Service ou Container App proxy  
**Afin de** déployer le point d'entrée HTTPS public

**Acceptance Criteria** :
- [ ] Fichier `infra/bicep/proxy.bicep`
- [ ] Support App Service ou Container Apps (paramétrable)
- [ ] Managed Identity configurée
- [ ] Custom domain + SSL certificate

**Priorité** : Must Have  
**Effort** : 13 points  
**Sprint** : Sprint 3  
**Statut** : 📋 To Do

---

#### US-403 : Ajouter GitHub Actions workflow CI/CD
**En tant que** DevOps engineer  
**Je veux** un pipeline GitHub Actions pour déployer automatiquement  
**Afin de** avoir une CI/CD complète

**Acceptance Criteria** :
- [ ] Workflow `.github/workflows/deploy-azure.yml`
- [ ] Trigger sur push main ou tag release
- [ ] Déploie Bicep templates avec Azure CLI
- [ ] Secrets stockés dans GitHub Secrets

**Priorité** : Should Have  
**Effort** : 8 points  
**Sprint** : Sprint 3  
**Statut** : 📋 To Do

---

#### US-404 : Alternative Terraform pour IaC
**En tant que** DevOps engineer préférant Terraform  
**Je veux** des modules Terraform équivalents aux Bicep  
**Afin de** utiliser mon outil préféré

**Acceptance Criteria** :
- [ ] Modules Terraform dans `infra/terraform/`
- [ ] Parité fonctionnelle avec Bicep
- [ ] Backend remote state (Azure Storage)
- [ ] Documentation choix Bicep vs Terraform

**Priorité** : Could Have  
**Effort** : 13 points  
**Sprint** : Sprint 4  
**Statut** : 📋 To Do

---

## 📊 Epic 5 : Observabilité et Monitoring

**Objectif** : Monitorer la santé et les performances du gateway  
**Personas** : Jordan (DevOps), Alex (Développeur)  
**Valeur Métier** : Réduction MTTR (Mean Time To Recovery)  
**Statut** : 📋 To Do

### User Stories

#### US-501 : Intégrer Application Insights
**En tant que** DevOps engineer  
**Je veux** envoyer les métriques vers Application Insights  
**Afin de** monitorer la santé en temps réel

**Acceptance Criteria** :
- [ ] SDK Application Insights dans relay_agent.py
- [ ] Métriques : latence, throughput, erreurs
- [ ] Custom events : relay connection, model inference
- [ ] Dashboard Application Insights pré-configuré

**Priorité** : Must Have  
**Effort** : 8 points  
**Sprint** : Sprint 3  
**Statut** : 📋 To Do

---

#### US-502 : Ajouter health checks endpoints
**En tant que** développeur  
**Je veux** des endpoints `/health` et `/ready`  
**Afin de** vérifier la connectivité rapidement

**Acceptance Criteria** :
- [ ] Endpoint `/health` sur LiteLLM, agent, proxy
- [ ] Checks : Ollama/macMLX accessible, Relay connected
- [ ] Réponse JSON structurée avec status par composant
- [ ] Script `scripts/check-health.sh` pour tester

**Priorité** : Must Have  
**Effort** : 5 points  
**Sprint** : Sprint 2  
**Statut** : 📋 To Do

---

#### US-503 : Créer dashboard Grafana (optionnel)
**En tant que** DevOps engineer  
**Je veux** visualiser les métriques dans Grafana  
**Afin de** avoir une vue consolidée

**Acceptance Criteria** :
- [ ] Stack Prometheus + Grafana (Docker Compose optionnel)
- [ ] Exporters pour LiteLLM et Ollama/macMLX
- [ ] Dashboard pré-configuré (latence, tokens/s, erreurs)
- [ ] Documentation setup Grafana

**Priorité** : Could Have  
**Effort** : 13 points  
**Sprint** : Sprint 4  
**Statut** : 📋 To Do

---

#### US-504 : Logs structurés JSON partout
**En tant que** DevOps engineer  
**Je veux** tous les logs en format JSON  
**Afin de** faciliter le parsing et l'analyse

**Acceptance Criteria** :
- [ ] Logging Python structuré (structlog ou python-json-logger)
- [ ] Champs standard : timestamp, level, component, request_id
- [ ] Redaction appliquée (US-302)
- [ ] Tests de format JSON

**Priorité** : Should Have  
**Effort** : 5 points  
**Sprint** : Sprint 3  
**Statut** : 📋 To Do

---

## 📈 Backlog Priorization Matrix

| Epic | Must Have | Should Have | Could Have | Total Points | Sprint Target |
|------|-----------|-------------|------------|--------------|---------------|
| **Epic 1 (macMLX)** | 2 stories (5 pts) | 1 story (2 pts) | 1 story (5 pts) | 12 pts | Sprint 1 |
| **Epic 2 (DevOps)** | 2 stories (16 pts) | 3 stories (11 pts) | 0 | 27 pts | Sprint 1-2 |
| **Epic 3 (Security)** | 3 stories (18 pts) | 1 story (5 pts) | 0 | 23 pts | Sprint 2 |
| **Epic 4 (IaC)** | 2 stories (21 pts) | 1 story (8 pts) | 1 story (13 pts) | 42 pts | Sprint 3-4 |
| **Epic 5 (Monitoring)** | 2 stories (13 pts) | 1 story (5 pts) | 1 story (13 pts) | 31 pts | Sprint 3-4 |

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

_Dernière mise à jour : 2026-06-05_
