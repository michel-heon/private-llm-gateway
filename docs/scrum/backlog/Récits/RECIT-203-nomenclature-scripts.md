# RECIT-203 : Standardiser nomenclature scripts existants

**Type** : Récit Utilisateur  
**ID** : RECIT-203  
**Épopée** : [EPOP-002](../Épopées/EPOP-002-patterns-devops.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** renommer les scripts selon [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md)  
**Afin de** avoir une cohérence `{object}-{action}.sh`

---

## ✅ Critères d'Acceptation

- [ ] Audit des scripts actuels (`scripts/`)
- [ ] Renommage selon pattern (ex: `start-ollama.sh` → `ollama-start.sh`)
- [ ] Mise à jour des références dans Makefile et docs
- [ ] Tests après renommage

---

## 📊 Informations

**Priorité** : Should Have  
**Effort** : 3 points  
**Sprint** : Sprint 1  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md) : Nomenclature scripts
- ✅ [RECIT-202](RECIT-202-makefile-orchestrateur.md) : Makefile (pour maj références)

---

## 📝 Plan de Renommage

### Scripts Existants

| Ancien Nom | Nouveau Nom | Justification |
|------------|-------------|---------------|
| `start-ollama.sh` | `ollama-start.sh` | Pattern {object}-{action} |
| `start-litellm.sh` | `litellm-start.sh` | Pattern {object}-{action} |
| `start-local-agent.sh` | `agent-start.sh` | Pattern {object}-{action} |
| `check-local-endpoint.sh` | `endpoint-check-local.sh` | Pattern {object}-{action}-{scope} |
| `check-public-endpoint.sh` | `endpoint-check-public.sh` | Pattern {object}-{action}-{scope} |

### Commandes Git

```bash
# Préserver l'historique avec git mv
git mv scripts/start-ollama.sh scripts/ollama-start.sh
git mv scripts/start-litellm.sh scripts/litellm-start.sh
git mv scripts/start-local-agent.sh scripts/agent-start.sh
git mv scripts/check-local-endpoint.sh scripts/endpoint-check-local.sh
git mv scripts/check-public-endpoint.sh scripts/endpoint-check-public.sh
```

---

## 🔍 Références à Mettre à Jour

### Makefile

```makefile
# Avant
start-ollama:
	@./scripts/start-ollama.sh

# Après
ollama-start:
	@./scripts/ollama-start.sh
```

### Documentation

- [ ] `README.md`
- [ ] `docs/guides/setup/litellm-ollama.md`
- [ ] `docs/guides/setup/local-macos-agent.md`
- [ ] `docs/scrum/sprints/current-sprint.md`

---

## 🧪 Tests

### Tests Post-Renommage

- [ ] Tous les scripts exécutables (`chmod +x`)
- [ ] `make ollama-start` fonctionne
- [ ] `make litellm-start` fonctionne
- [ ] `make agent-start` fonctionne
- [ ] Documentation à jour
- [ ] Liens internes fonctionnels

---

## 📋 Checklist Implémentation

- [ ] Auditer scripts existants
- [ ] Planifier renommages (tableau ci-dessus)
- [ ] Renommer avec `git mv` (préserver historique)
- [ ] Mettre à jour Makefile
- [ ] Mettre à jour README.md
- [ ] Mettre à jour documentation guides/
- [ ] Tester tous les scripts
- [ ] Commit avec message descriptif
- [ ] Vérifier GitHub (rename detection 100%)

---

_Dernière mise à jour : 2026-06-05_
