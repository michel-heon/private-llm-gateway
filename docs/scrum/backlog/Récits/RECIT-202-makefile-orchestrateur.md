# RECIT-202 : Créer Makefile orchestrateur principal

**Type** : Récit Utilisateur  
**ID** : RECIT-202  
**Épopée** : [EPOP-002](../Épopées/EPOP-002-patterns-devops.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** un Makefile avec cibles standardisées  
**Afin de** lancer tous les composants uniformément

---

## ✅ Critères d'Acceptation

- [ ] Makefile avec cibles : `setup`, `config`, `start`, `stop`, `test`, `clean`
- [ ] Respecte [ADR-602](../../adr/602-DEVOPS-makefile-orchestrateur.md) (règle des 3 lignes)
- [ ] Gère les dépendances entre cibles (ex: `start` nécessite `config`)
- [ ] Aide intégrée `make help`

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 8 points  
**Sprint** : Sprint 1  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [ADR-602](../../adr/602-DEVOPS-makefile-orchestrateur.md) : Makefile orchestrateur
- 📄 [ADR-605](../../adr/605-DEVOPS-gestion-couleurs-scripts-make.md) : Couleurs ANSI
- ✅ [RECIT-201](RECIT-201-bootstrap-config.md) : Configuration bootstrap (requis)

---

## 📝 Spécifications Techniques

### Cibles Principales

```makefile
.DEFAULT_GOAL := help

## help: Afficher l'aide
help:
	@printf "$(BOLD)Commandes disponibles:$(RESET)\n"
	@grep -E '^## ' Makefile | sed 's/## //'

## setup: Installation dépendances
setup:
	@printf "$(GREEN)📦 Installation dépendances...$(RESET)\n"
	@./scripts/setup-dependencies.sh

## config: Génération configurations
config:
	@printf "$(BLUE)⚙️  Configuration système...$(RESET)\n"
	@./scripts/config-bootstrap.sh

## start: Démarrer tous les services
start: config
	@printf "$(GREEN)🚀 Démarrage services...$(RESET)\n"
	@./scripts/system-start.sh

## stop: Arrêter tous les services
stop:
	@printf "$(YELLOW)🛑 Arrêt services...$(RESET)\n"
	@./scripts/system-stop.sh

## test: Exécuter tests
test:
	@printf "$(CYAN)🧪 Exécution tests...$(RESET)\n"
	@./scripts/tests-run.sh

## clean: Nettoyer artifacts
clean:
	@printf "$(RED)🗑️  Nettoyage...$(RESET)\n"
	@./scripts/system-clean.sh
```

### Couleurs ANSI (ADR-605)

```makefile
# Couleurs
RESET  := \033[0m
BOLD   := \033[1m
RED    := \033[31m
GREEN  := \033[32m
YELLOW := \033[33m
BLUE   := \033[34m
CYAN   := \033[36m
```

### Règle des 3 Lignes (ADR-602)

Chaque cible doit :
1. Logger l'action
2. Déléguer au script
3. (Optionnel) Gérer le retour

---

## 🧪 Tests

### Tests Manuels

- [ ] `make help` affiche aide complète
- [ ] `make setup` installe dépendances
- [ ] `make config` génère configurations
- [ ] `make start` démarre tous services
- [ ] `make stop` arrête tous services
- [ ] `make test` exécute tests
- [ ] `make clean` nettoie artifacts

### Tests de Dépendances

- [ ] `make start` appelle `make config` automatiquement
- [ ] Erreur si config échoue avant start
- [ ] Couleurs affichées correctement

---

## 📋 Checklist Implémentation

- [ ] Créer Makefile racine
- [ ] Définir variables couleurs
- [ ] Implémenter cible `help`
- [ ] Implémenter cible `setup`
- [ ] Implémenter cible `config`
- [ ] Implémenter cible `start` (avec dépendance)
- [ ] Implémenter cible `stop`
- [ ] Implémenter cible `test`
- [ ] Implémenter cible `clean`
- [ ] Tester toutes les cibles
- [ ] Documenter dans README

---

_Dernière mise à jour : 2026-06-05_
