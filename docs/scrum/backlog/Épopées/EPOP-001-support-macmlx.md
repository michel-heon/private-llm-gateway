# EPOP-001 : Support macMLX Complet

**Type** : Épopée  
**ID** : EPOP-001  
**Statut** : 🟢 En cours  
**Sprint** : Sprint 1

---

## 📋 Vue d'Ensemble

**Objectif** : Offrir macMLX comme alternative performante à Ollama sur Apple Silicon

**Valeur Métier** : 2x speedup pour les utilisateurs Mac M1/M2/M3/M4

**Personas Concernés** :
- 🔴 Alex (Développeur) — Critique
- 🔴 Sam (Utilisateur) — Critique

---

## 🎯 Objectifs

1. Documenter l'installation et la configuration de macMLX
2. Créer des scripts de démarrage automatisé
3. Intégrer macMLX dans le Makefile orchestrateur
4. Permettre le switch facile entre Ollama et macMLX

---

## 📊 Métriques de Succès

| Métrique | Cible | Actuel |
|----------|-------|--------|
| **Performance** | 80-100 tokens/sec (M2 Max) | ✅ Documenté |
| **Temps de setup** | <5 minutes | 🚧 En cours |
| **Satisfaction utilisateur** | ≥4/5 | 📊 À mesurer |

---

## 🗂️ Récits Utilisateurs

| ID | Récit | Priorité | Effort | Statut |
|----|-------|----------|--------|--------|
| [RECIT-101](../Récits/RECIT-101-documenter-macmlx.md) | Documenter installation macMLX | Must Have | 2 pts | ✅ Complété |
| [RECIT-102](../Récits/RECIT-102-script-demarrage-macmlx.md) | Script démarrage macMLX | Must Have | 3 pts | 📋 To Do |
| [RECIT-103](../Récits/RECIT-103-makefile-macmlx.md) | Cibles Makefile macMLX | Should Have | 2 pts | 📋 To Do |
| [RECIT-104](../Récits/RECIT-104-dual-runtime.md) | Configuration dual runtime | Could Have | 5 pts | 📋 To Do |

**Total** : 4 récits, 12 points

---

## 📈 Progression

```
Progress: ██████░░░░░░░░░░░░░░ 25% (1/4 récits)
Points:   ██░░░░░░░░░░░░░░░░░░ 17% (2/12 points)
```

**Récits complétés** : 1/4 (25%)  
**Points complétés** : 2/12 (17%)

---

## 🔗 Dépendances

### Dépendances Externes
- 🍺 Homebrew installé sur macOS
- 🍎 Apple Silicon (M1/M2/M3/M4)
- 🐍 Python ≥3.9 pour scripts

### Dépendances Internes
- 📄 ADR-601 (Nomenclature scripts) pour RECIT-102
- 📄 ADR-602 (Makefile orchestrateur) pour RECIT-103
- 🛠️ Epic 2 (DevOps) pour configuration système

---

## ⚠️ Risques Identifiés

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| macMLX instable (v0.5.0) | Moyenne | Élevé | Fallback vers Ollama |
| Modèles MLX limités | Élevée | Moyen | Documenter conversions |
| Incompatibilité M1 early | Faible | Faible | Tester sur M1/M2/M3 |

---

## 🎓 Learnings et Décisions

### 2026-06-05 : Documentation macMLX complétée
- ✅ Benchmark M2 Max confirmé : 80-100 tokens/sec vs 40-50 Ollama
- ✅ Port 8080 par défaut pour éviter conflit Ollama
- 📝 Bibliothèque modèles MLX plus petite que Ollama (à documenter)

### Décisions Techniques
- **Runtime par défaut** : macMLX recommandé pour Apple Silicon
- **Fallback** : Ollama reste supporté pour compatibilité
- **Configuration** : Variable `LLM_RUNTIME` pour switch futur (RECIT-104)

---

## 📅 Timeline

| Phase | Début | Fin | Statut |
|-------|-------|-----|--------|
| **Documentation** | 2026-06-05 | 2026-06-05 | ✅ Complété |
| **Scripts** | 2026-06-06 | 2026-06-10 | 🚧 En cours |
| **Makefile** | 2026-06-11 | 2026-06-13 | 📋 Planifié |
| **Dual Runtime** | 2026-06-20 | 2026-06-25 | 📋 Sprint 2 |

---

## 🔄 Historique

| Date | Action | Auteur |
|------|--------|--------|
| 2026-06-05 | Création épopée | Alex |
| 2026-06-05 | RECIT-101 complété | Alex |
| 2026-06-05 | Documentation mise à jour | Alex |

---

_Dernière mise à jour : 2026-06-05_
