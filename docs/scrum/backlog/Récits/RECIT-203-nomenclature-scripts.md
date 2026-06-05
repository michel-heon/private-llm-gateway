# RECIT-203 : Standardiser nomenclature scripts existants

**Type** : Récit Utilisateur  
**ID** : RECIT-203  
**Épopée** : [EPOP-002](../Épopées/EPOP-002-patterns-devops.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** standardiser la nomenclature des scripts selon [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md)  
**Afin de** garantir la cohérence et la découvrabilité

> ⚠️ **Note importante** : L'ADR-601 accepte le pattern `{action}-{object}` (ex: `start-ollama.sh`) pour les scripts existants. Ce récit se concentre sur la **documentation** et la **validation** de la conformité, pas sur le renommage.

---

## ✅ Critères d'Acceptation

- [ ] Audit des scripts actuels (`scripts/`) - vérifier conformité ADR-601
- [ ] Créer `scripts/README.md` avec liste et description de tous les scripts
- [ ] Valider que tous les scripts suivent le pattern `{action}-{object}` ou `{object}-{action}`
- [ ] Documenter conventions dans le README du projet

---

## 📊 Informations

**Priorité** : Should Have  
**Effort** : 3 points  
**Sprint** : Sprint 1  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md) : Nomenclature scripts
- ✅ [RECIT-202](RECIT-202-makefile-orchestrateur.md) : Makefile (pour cohérence targets)

---

## 📝 Plan d'Audit et Documentation

### Scripts Existants (Conformité ADR-601)

| Script Actuel | Pattern | Statut | Notes |
|---------------|---------|--------|-------|
| `start-ollama.sh` | `{action}-{object}` | ✅ Conforme | Pattern accepté par ADR-601 |
| `start-litellm.sh` | `{action}-{object}` | ✅ Conforme | Pattern accepté par ADR-601 |
| `start-local-agent.sh` | `{action}-{object}` | ✅ Conforme | Pattern accepté par ADR-601 |
| `check-local-endpoint.sh` | `{action}-{object}-{scope}` | ✅ Conforme | Pattern accepté par ADR-601 |
| `check-public-endpoint.sh` | `{action}-{object}-{scope}` | ✅ Conforme | Pattern accepté par ADR-601 |

**Conclusion** : Tous les scripts existants sont conformes à l'ADR-601 (pattern `{action}-{object}`).

### Contenu du `scripts/README.md`

```markdown
# Scripts d'Automatisation

Ce répertoire contient les scripts d'automatisation du projet **private-llm-gateway**.

## Convention de Nommage

Tous les scripts suivent la nomenclature **ADR-601** : `{action}-{object}.sh`

## Scripts Disponibles

### Services Locaux

- **`start-ollama.sh`** : Démarre Ollama en local
- **`start-litellm.sh`** : Démarre LiteLLM gateway
- **`start-local-agent.sh`** : Démarre l'agent local (relay_agent.py)

### Vérifications

- **`check-local-endpoint.sh`** : Vérifie que l'endpoint local LiteLLM répond
- **`check-public-endpoint.sh`** : Vérifie que l'endpoint public Azure répond

### Usage

\```bash
# Démarrer tous les services locaux
make start

# Vérifier les endpoints
./scripts/check-local-endpoint.sh
\```

Voir [ADR-601](../docs/adr/601-DEVOPS-nomenclature-scripts.md) pour la convention complète.
```

---

## 🧪 Tests & Validation

### Checklist de Validation

```bash
# 1. Audit des scripts
ls -la scripts/*.sh

# 2. Vérifier conformité nommage
for script in scripts/*.sh; do
  basename "$script"
done

# 3. Valider que tous fonctionnent
make help           # Liste targets Makefile
make start-ollama   # Test target
```

### Critères de Validation

- [ ] Tous les scripts suivent pattern `{action}-{object}` ou `{object}-{action}`
- [ ] `scripts/README.md` créé et complet
- [ ] Documentation à jour dans README principal
- [ ] Targets Makefile cohérents avec noms de scripts

---

## 📋 Checklist d'Implémentation

- [ ] Lister tous les scripts dans `scripts/`
- [ ] Vérifier conformité avec ADR-601
- [ ] Créer `scripts/README.md`
- [ ] Ajouter section "Scripts" dans README principal
- [ ] Valider cohérence Makefile targets
- [ ] Tests manuels de tous les scripts
- [ ] Commit et PR

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
