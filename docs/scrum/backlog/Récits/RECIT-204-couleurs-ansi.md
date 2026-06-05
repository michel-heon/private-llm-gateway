# RECIT-204 : Ajouter couleurs ANSI aux scripts

**Type** : Récit Utilisateur  
**ID** : RECIT-204  
**Épopée** : [EPOP-002](../Épopées/EPOP-002-patterns-devops.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** des logs colorés dans les scripts bash  
**Afin de** identifier rapidement les erreurs/succès

---

## ✅ Critères d'Acceptation

- [ ] Macros printf dans Makefile ([ADR-605](../../adr/605-DEVOPS-gestion-couleurs-scripts-make.md))
- [ ] Fonctions bash `log_info`, `log_success`, `log_error`
- [ ] Couleurs appliquées à tous les scripts
- [ ] Compatible macOS et Linux

---

## 📊 Informations

**Priorité** : Should Have  
**Effort** : 3 points  
**Sprint** : Sprint 2  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [ADR-605](../../adr/605-DEVOPS-gestion-couleurs-scripts-make.md) : Couleurs ANSI
- ✅ [RECIT-202](RECIT-202-makefile-orchestrateur.md) : Makefile (déjà défini couleurs)

---

## 📝 Spécifications Techniques

### Bibliothèque Bash (`scripts/lib/colors.sh`)

```bash
#!/usr/bin/env bash
# scripts/lib/colors.sh
# Bibliothèque de couleurs ANSI pour scripts Bash

# Couleurs
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'

# Fonctions de logging
log_info() {
    printf "${BLUE}ℹ️  $*${RESET}\n"
}

log_success() {
    printf "${GREEN}✅ $*${RESET}\n"
}

log_warning() {
    printf "${YELLOW}⚠️  $*${RESET}\n"
}

log_error() {
    printf "${RED}❌ $*${RESET}\n" >&2
}

log_step() {
    printf "${CYAN}🔹 $*${RESET}\n"
}
```

### Utilisation dans Scripts

```bash
#!/usr/bin/env bash
# scripts/ollama-start.sh

# Source la bibliothèque
source "$(dirname "$0")/lib/colors.sh"

log_info "Démarrage Ollama..."
if command -v ollama &> /dev/null; then
    log_success "Ollama trouvé"
    ollama serve
else
    log_error "Ollama non installé"
    exit 1
fi
```

### Standards de Couleur

| Type | Couleur | Icône | Usage |
|------|---------|-------|-------|
| Info | Bleu | ℹ️ | Informations générales |
| Success | Vert | ✅ | Opérations réussies |
| Warning | Jaune | ⚠️ | Avertissements |
| Error | Rouge | ❌ | Erreurs |
| Step | Cyan | 🔹 | Étapes de progression |

---

## 🧪 Tests

### Tests Visuels

- [ ] Couleurs affichées correctement sur macOS Terminal
- [ ] Couleurs affichées correctement sur Linux (bash/zsh)
- [ ] Fallback si terminal ne supporte pas couleurs
- [ ] Erreurs envoyées sur stderr (>&2)

### Tests d'Intégration

- [ ] Tous les scripts utilisent `log_*` fonctions
- [ ] Makefile utilise printf avec couleurs
- [ ] Logs lisibles en contexte CI/CD (GitHub Actions)

---

## 📋 Checklist Implémentation

- [ ] Créer `scripts/lib/colors.sh`
- [ ] Définir variables couleurs
- [ ] Implémenter fonctions `log_*`
- [ ] Mettre à jour `scripts/ollama-start.sh`
- [ ] Mettre à jour `scripts/litellm-start.sh`
- [ ] Mettre à jour `scripts/agent-start.sh`
- [ ] Mettre à jour `scripts/endpoint-check-*.sh`
- [ ] Mettre à jour Makefile (déjà fait)
- [ ] Tester visuellement
- [ ] Documenter dans README

---

_Dernière mise à jour : 2026-06-05_
