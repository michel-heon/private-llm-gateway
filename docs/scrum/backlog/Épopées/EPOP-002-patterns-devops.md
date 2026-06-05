# EPOP-002 : Implémentation Patterns DevOps (ADR 600-607)

**Type** : Épopée  
**ID** : EPOP-002  
**Statut** : 📋 To Do  
**Sprint** : Sprint 1-2

---

## 📋 Vue d'Ensemble

**Objectif** : Automatiser la gestion de config, scripts et Makefile selon les patterns ADR 600-607

**Valeur Métier** : Réduction de 60% du temps de setup

**Personas Concernés** :
- 🔴 Alex (Développeur) — Critique
- 🟡 Jordan (DevOps) — Important

---

## 🎯 Objectifs

1. Implémenter système de configuration multi-format (ADR-600)
2. Créer Makefile orchestrateur principal (ADR-602)
3. Standardiser nomenclature scripts (ADR-601)
4. Ajouter couleurs ANSI aux logs (ADR-605)
5. Implémenter parsing d'options Bash standard (ADR-607)

---

## 📊 Métriques de Succès

| Métrique | Cible | Actuel |
|----------|-------|--------|
| **Temps setup** | <10 minutes | 📊 Baseline à établir |
| **Scripts conformes ADR-601** | 100% | ✅ 100% (scripts existants déjà conformes) |
| **Documentation scripts** | scripts/README.md | 🚧 À créer |
| **Couverture tests** | ≥80% | 🚧 À implémenter |

> ⚠️ **Note** : L'ADR-601 accepte le pattern `{action}-{object}` des scripts existants. Aucun renommage nécessaire.

---

## 🗂️ Récits Utilisateurs

| ID | Récit | Priorité | Effort | Statut |
|----|-------|----------|--------|--------|
| [RECIT-201](../Récits/RECIT-201-bootstrap-config.md) | Bootstrap configuration multi-format | Must Have | 8 pts | 📋 To Do |
| [RECIT-202](../Récits/RECIT-202-makefile-orchestrateur.md) | Makefile orchestrateur | Must Have | 8 pts | 📋 To Do |
| [RECIT-203](../Récits/RECIT-203-nomenclature-scripts.md) | Nomenclature scripts | Should Have | 3 pts | 📋 To Do |
| [RECIT-204](../Récits/RECIT-204-couleurs-ansi.md) | Couleurs ANSI | Should Have | 3 pts | 📋 To Do |
| [RECIT-205](../Récits/RECIT-205-parsing-options-bash.md) | Parsing options Bash | Should Have | 5 pts | 📋 To Do |

**Total** : 5 récits, 27 points

---

## 📈 Progression

```
Progress: ░░░░░░░░░░░░░░░░░░░░ 0% (0/5 récits)
Points:   ░░░░░░░░░░░░░░░░░░░░ 0% (0/27 points)
```

**Récits complétés** : 0/5 (0%)  
**Points complétés** : 0/27 (0%)

---

## 🔗 Dépendances

### Dépendances ADRs
- 📄 [ADR-600](../../adr/600-DEVOPS-bootstrap-configuration-management.md) : Configuration management
- 📄 [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md) : Nomenclature scripts
- 📄 [ADR-602](../../adr/602-DEVOPS-makefile-orchestrateur.md) : Makefile orchestrateur
- 📄 [ADR-605](../../adr/605-DEVOPS-gestion-couleurs-scripts-make.md) : Couleurs ANSI
- 📄 [ADR-607](../../adr/607-DEVOPS-gestion-options-scripts-bash.md) : Options Bash

### Dépendances entre Récits
- 🔗 RECIT-202 nécessite RECIT-201 complété (hard dependency)
- 🔗 RECIT-203 précède RECIT-205 (nomenclature avant parsing)
- 🔗 RECIT-204 peut être parallèle (soft dependency)

---

## ⚠️ Risques Identifiés

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| RECIT-201 sous-estimé | Moyenne | Élevé | Découper si >3 jours |
| Complexité parsing .env | Moyenne | Moyen | POC avec test .env |
| Tests scripts chronophages | Élevée | Moyen | Prioriser Must Have |

---

## 🎓 Learnings et Décisions

### Décisions Architecturales
- **Configuration 3 couches** : .env → .env.user → formats générés
- **Makefile = Interface UX** : Toute action via `make <target>`
- **Scripts = Business Logic** : Règle des 3 lignes dans Make

### Scripts à Renommer (RECIT-203)
```
start-ollama.sh          → ollama-start.sh
start-litellm.sh         → litellm-start.sh
start-local-agent.sh     → agent-start.sh
check-local-endpoint.sh  → endpoint-check-local.sh
check-public-endpoint.sh → endpoint-check-public.sh
```

---

## 📅 Timeline

| Phase | Début | Fin | Statut |
|-------|-------|-----|--------|
| **Configuration** | 2026-06-09 | 2026-06-12 | 📋 Sprint 1 |
| **Makefile** | 2026-06-12 | 2026-06-16 | 📋 Sprint 1 |
| **Nomenclature** | 2026-06-17 | 2026-06-18 | 📋 Sprint 1 |
| **Couleurs + Parsing** | 2026-06-20 | 2026-06-27 | 📋 Sprint 2 |

---

## 🔄 Historique

| Date | Action | Auteur |
|------|--------|--------|
| 2026-06-05 | Création épopée | Alex |
| 2026-06-05 | ADRs 600-607 déjà documentés | Alex |

---

_Dernière mise à jour : 2026-06-05_
