# RECIT-205 : Implémenter parsing d'options Bash standard

**Type** : Récit Utilisateur  
**ID** : RECIT-205  
**Épopée** : [EPOP-002](../Épopées/EPOP-002-patterns-devops.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** que tous les scripts supportent `-h/--help`, `-v/--verbose`  
**Afin de** avoir une interface utilisateur cohérente

---

## ✅ Critères d'Acceptation

- [ ] Pattern while/case/shift dans tous les scripts ([ADR-607](../../adr/607-DEVOPS-gestion-options-scripts-bash.md))
- [ ] Options standard : `-h`, `-v`, `-n` (dry-run), `-o` (output)
- [ ] Fonction `_usage()` obligatoire
- [ ] Tests des options pour chaque script

---

## 📊 Informations

**Priorité** : Should Have  
**Effort** : 5 points  
**Sprint** : Sprint 2  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [ADR-607](../../adr/607-DEVOPS-gestion-options-scripts-bash.md) : Parsing options Bash
- ✅ [RECIT-203](RECIT-203-nomenclature-scripts.md) : Nomenclature (scripts renommés)

---

## 📝 Spécifications Techniques

### Template de Script Bash

```bash
#!/usr/bin/env bash
# scripts/ollama-start.sh

set -euo pipefail

# Variables globales
VERBOSE=0
DRY_RUN=0
MODEL="qwen2.5-coder:32b"

# Fonction usage
_usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Description:
    Démarre le serveur Ollama

Options:
    -m, --model MODEL    Modèle à charger (défaut: $MODEL)
    -v, --verbose        Mode verbeux
    -n, --dry-run        Simulation (ne fait rien)
    -h, --help           Afficher cette aide

Exemples:
    $(basename "$0")
    $(basename "$0") --model llama3.2:3b --verbose
EOF
}

# Parsing des options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -m|--model)
            MODEL="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -n|--dry-run)
            DRY_RUN=1
            shift
            ;;
        -h|--help)
            _usage
            exit 0
            ;;
        *)
            echo "❌ Option inconnue: $1"
            _usage
            exit 1
            ;;
    esac
done

# Logique principale
[[ $VERBOSE -eq 1 ]] && echo "Mode verbeux activé"
[[ $DRY_RUN -eq 1 ]] && echo "Dry-run: ollama serve --model $MODEL" && exit 0

ollama serve --model "$MODEL"
```

### Options Standard

| Option Courte | Option Longue | Description | Obligatoire |
|---------------|---------------|-------------|-------------|
| `-h` | `--help` | Afficher aide | ✅ Oui |
| `-v` | `--verbose` | Mode verbeux | ✅ Oui |
| `-n` | `--dry-run` | Simulation | ⚠️ Si applicable |
| `-o` | `--output` | Fichier sortie | ⚠️ Si applicable |

---

## 🧪 Tests

### Tests Unitaires par Script

- [ ] `script.sh --help` affiche usage
- [ ] `script.sh -h` affiche usage
- [ ] `script.sh --verbose` active logs
- [ ] `script.sh --dry-run` simule (si applicable)
- [ ] `script.sh --unknown` retourne erreur

### Tests d'Intégration

- [ ] Toutes les options cohérentes entre scripts
- [ ] Aide formatée uniformément
- [ ] Erreurs claires si option manquante

---

## 📋 Checklist Implémentation

### Scripts à Mettre à Jour

- [ ] `scripts/ollama-start.sh`
- [ ] `scripts/litellm-start.sh`
- [ ] `scripts/agent-start.sh`
- [ ] `scripts/macmlx-start.sh` (si créé)
- [ ] `scripts/config-bootstrap.sh`
- [ ] `scripts/endpoint-check-local.sh`
- [ ] `scripts/endpoint-check-public.sh`

### Pour Chaque Script

- [ ] Ajouter fonction `_usage()`
- [ ] Implémenter parsing while/case/shift
- [ ] Ajouter options `-h`, `-v`
- [ ] Ajouter `-n` (dry-run) si applicable
- [ ] Tester toutes les options
- [ ] Mettre à jour documentation

---

_Dernière mise à jour : 2026-06-05_
