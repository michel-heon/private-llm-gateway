# RECIT-201 : Implémenter bootstrap configuration multi-format

**Type** : Récit Utilisateur  
**ID** : RECIT-201  
**Épopée** : [EPOP-002](../Épopées/EPOP-002-patterns-devops.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** un système de configuration 3 couches (.env → .env.user → formats générés)  
**Afin de** éviter les conflits entre environnements et formats

---

## ✅ Critères d'Acceptation

- [ ] Script `scripts/config-bootstrap.sh` créé
- [ ] Génère `env.sh`, `env.docker`, `env.mk` depuis .env
- [ ] Respecte [ADR-600](../../adr/600-DEVOPS-bootstrap-configuration-management.md)
- [ ] Tests de génération avec différents .env

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 8 points  
**Sprint** : Sprint 1  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [ADR-600](../../adr/600-DEVOPS-bootstrap-configuration-management.md) : Configuration management
- 📄 [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md) : Nomenclature scripts

---

## 📝 Spécifications Techniques

### Architecture 3 Couches

```
.env (Défauts projet)
  ↓ override
.env.user (Overrides utilisateur, gitignore)
  ↓ génération
env.sh, env.docker, env.mk (Formats cibles)
```

### Script config-bootstrap.sh

```bash
#!/usr/bin/env bash
# scripts/config-bootstrap.sh
# Génère les fichiers de configuration dérivés

config-bootstrap.sh [OPTIONS]

Options:
  --clean            Supprimer configs générés
  --validate         Valider les variables requises
  -h, --help         Afficher l'aide
```

### Formats Générés

1. **env.sh** (Source Bash) :
   ```bash
   export AZURE_RELAY_CONNECTION_STRING="Endpoint=..."
   export LLM_RUNTIME="macmlx"
   ```

2. **env.docker** (Docker Compose) :
   ```
   AZURE_RELAY_CONNECTION_STRING=Endpoint=...
   LLM_RUNTIME=macmlx
   ```

3. **env.mk** (Variables Make) :
   ```makefile
   AZURE_RELAY_CONNECTION_STRING := Endpoint=...
   LLM_RUNTIME := macmlx
   ```

### Variables Requises

| Variable | Description | Défaut |
|----------|-------------|--------|
| `AZURE_RELAY_CONNECTION_STRING` | Connection string Relay | (requis) |
| `LLM_RUNTIME` | Runtime LLM | `ollama` |
| `LITELLM_PORT` | Port LiteLLM | `4000` |

---

## 🧪 Tests

### Tests Unitaires

- [ ] Génération `env.sh` correcte
- [ ] Génération `env.docker` correcte
- [ ] Génération `env.mk` correcte
- [ ] Override .env.user fonctionne
- [ ] Validation détecte variables manquantes
- [ ] Option `--clean` supprime les fichiers

### Tests d'Intégration

- [ ] Makefile peut inclure `env.mk`
- [ ] Scripts bash peuvent sourcer `env.sh`
- [ ] Docker Compose utilise `env.docker`

---

## 📋 Checklist Implémentation

- [ ] Créer `scripts/config-bootstrap.sh`
- [ ] Implémenter parsing .env + .env.user
- [ ] Implémenter génération env.sh
- [ ] Implémenter génération env.docker
- [ ] Implémenter génération env.mk
- [ ] Ajouter validation variables requises
- [ ] Ajouter option --clean
- [ ] Créer tests unitaires
- [ ] Documenter dans README
- [ ] Mettre à jour Makefile (cible `config`)

---

_Dernière mise à jour : 2026-06-05_
