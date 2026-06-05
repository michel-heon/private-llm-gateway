# RECIT-203 : Standardiser nomenclature scripts existants

**Type** : Récit Utilisateur  
**ID** : RECIT-203  
**Épopée** : [EPOP-002](../Épopées/EPOP-002-patterns-devops.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** renommer les scripts selon [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md) (pattern `{object}-{action}`)  
**Afin de** avoir une nomenclature cohérente et découvrable

---

## ✅ Critères d'Acceptation

- [ ] Audit des scripts actuels (`scripts/`)
- [ ] Renommage selon pattern `{object}-{action}.sh`
- [ ] Mise à jour des références dans Makefile et documentation
- [ ] Tests après renommage (vérifier que tout fonctionne)
- [ ] Création de `scripts/README.md`

---

## 📊 Informations

**Priorité** : Should Have  
**Effort** : 3 points  
**Sprint** : Sprint 1  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md) : Nomenclature scripts (pattern `{object}-{action}`)
- ✅ [RECIT-202](RECIT-202-makefile-orchestrateur.md) : Makefile (pour mise à jour des targets)

---

## 📝 Plan de Renommage

### Scripts Existants → Nouveaux Noms

| Ancien Nom (❌ non conforme) | Nouveau Nom (✅ ADR-601) | Pattern |
|------------------------------|--------------------------|---------|
| `start-ollama.sh` | `ollama-start.sh` | `{object}-{action}` |
| `start-litellm.sh` | `litellm-start.sh` | `{object}-{action}` |
| `start-local-agent.sh` | `local-agent-start.sh` | `{object}-{action}` |
| `check-local-endpoint.sh` | `local-endpoint-check.sh` | `{object}-{action}` |
| `check-public-endpoint.sh` | `public-endpoint-check.sh` | `{object}-{action}` |

### Commandes de Renommage

```bash
# Préserver l'historique Git avec git mv
cd scripts/

git mv start-ollama.sh ollama-start.sh
git mv start-litellm.sh litellm-start.sh  
git mv start-local-agent.sh local-agent-start.sh
git mv check-local-endpoint.sh local-endpoint-check.sh
git mv check-public-endpoint.sh public-endpoint-check.sh
```

---

## 🔄 Références à Mettre à Jour

### 1. Makefile

```makefile
# Avant
start-ollama:
	@./scripts/start-ollama.sh

# Après  
ollama-start:
	@./scripts/ollama-start.sh
```

### 2. Documentation

Fichiers à mettre à jour :
- `README.md` (section "Quick Start")
- `docs/litellm-ollama.md`
- `docs/local-macos-agent.md`
- `docs/scrum/sprints/current-sprint.md`

### Documentation à Mettre à Jour

- [ ] `scripts/README.md` (à créer)
- [ ] `README.md` (ajouter section Scripts)
- [ ] `docs/guides/setup/litellm-ollama.md` (si nécessaire)
- [ ] `docs/guides/setup/local-macos-agent.md` (si nécessaire)

---

## 🧪 Tests

### Tests de Validation

```bash
# Vérifier que tous les scripts sont exécutables
ls -l scripts/*.sh | grep -v 'x'

# Tester chaque script
./scripts/check-local-endpoint.sh
./scripts/check-public-endpoint.sh

# Vérifier targets Makefile
make help
```

### Critères de Succès

- [ ] Tous les scripts sont exécutables (`chmod +x`)
- [ ] `scripts/README.md` existe et liste tous les scripts
- [ ] Documentation principale mise à jour
- [ ] Aucun lien mort dans la documentation
- [ ] Targets Makefile cohérents avec nomenclature

---

_Dernière mise à jour : 2026-06-05_
 avec nouveaux noms)
- [ ] `README.md` (section Quick Start)
- [ ] `docs/litellm-ollama.md` (références scripts)
- [ ] `docs/local-macos-agent.md` (références scripts)

---

## 🧪 Tests

### Tests Post-Renommage

```bash
# Vérifier que les scripts sont exécutables
ls -l scripts/*.sh | grep 'x'

# Tester chaque script renommé
./scripts/ollama-start.sh --help
./scripts/litellm-start.sh --help
./scripts/local-agent-start.sh --help
./scripts/local-endpoint-check.sh
./scripts/public-endpoint-check.sh

# Vérifier targets Makefile
make ollama-start
make litellm-start
```

### Critères de Succès

- [ ] Tous les scripts renommés sont exécutables
- [ ] Aucun lien mort dans la documentation
- [ ] Targets Makefile fonctionnent avec nouveaux noms
- [ ] `git log --follow` montre l'historique préservé
- [ ] GitHub détecte les renommages à 100%