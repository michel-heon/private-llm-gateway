# Sprint 1 (2026-06-05 → 2026-06-19)

**Sprint Goal** : Support macMLX complet + Fondations DevOps (Configuration, Makefile, Scripts)

---

## 📊 Vue d'Ensemble

| Métrique | Valeur |
|----------|--------|
| **Durée** | 2 semaines (10 jours ouvrables) |
| **Capacité** | 20-25 story points |
| **Stories planifiées** | 6 stories (19 points) |
| **Stories complétées** | 1/6 (5%) |
| **Vélocité actuelle** | 2 points / jour 1 |

---

## 🎯 Sprint Goal

À la fin du sprint, nous aurons :
1. ✅ **Documentation macMLX complète** (installatio, config, benchmark)
2. 🚧 **Scripts de démarrage macMLX** (`macmlx-start.sh`, cibles Make)
3. 🚧 **Système de configuration multi-format** (bootstrap .env)
4. 🚧 **Makefile orchestrateur** avec cibles standardisées
5. 🚧 **Scripts renommés** selon pattern `{object}-{action}` (ADR-601)

**Critère de succès** : Un utilisateur Mac M1/M2/M3 peut démarrer macMLX + LiteLLM avec `make macmlx-start` en une commande.

---

## ✅ Definition of Done & Principes

### Definition of Done (DoD)

Une User Story est considérée "Done" quand :
- [ ] Code implémenté et testé
- [ ] Tests unitaires/intégration passent
- [ ] Documentation mise à jour
- [ ] **ADR respectés** (vérifier [`docs/adr/`](../../adr/) pour le domaine)
- [ ] Code reviewé et approuvé
- [ ] Commit avec message conventionnel (`feat:`, `fix:`, etc.)
- [ ] Déployable sur environnement de test

### Principes du Sprint

> **⚠️ Respect des ADR (Architecture Decision Records)**
> 
> Toute implémentation doit **respecter les décisions architecturales** :
> - Consulter les ADR pertinents **avant** de coder
> - Exemples : [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md) (nomenclature scripts), [ADR-600](../../adr/600-DEVOPS-bootstrap-configuration-management.md) (configuration)
> - En cas de doute ou besoin de nouvelle décision : créer un ADR

---

## 📋 Sprint Backlog

### ✅ Complétées

#### US-101 : Documenter installation et configuration macMLX
- **Epic** : Epic 1 (macMLX Support)
- **Effort** : 2 points
- **Assigné** : Alex
- **Statut** : ✅ **Complété** (2026-06-05)

**Travaux réalisés** :
- [x] Documentation macMLX dans `docs/guides/setup/litellm-ollama.md`
- [x] Tableau comparatif Ollama vs macMLX
- [x] Configuration LiteLLM pour port 8080
- [x] Benchmark M2 Max (2x speedup)
- [x] Mise à jour `docs/architecture/overview.md`

**Commit** : `b4b5ed9` (2026-06-05)

---

### 🚧 En Cours

#### US-102 : Créer script de démarrage macMLX
- **Epic** : Epic 1 (macMLX Support)
- **Effort** : 3 points
- **Assigné** : Alex
- **Statut** : 🚧 **In Progress**

**Tâches** :
- [ ] Créer `scripts/start-macmlx.sh`
- [ ] Implémenter options `--model`, `--port`, `--verbose`
- [ ] Gestion erreurs (macMLX non installé, port occupé)
- [ ] Tests avec différents modèles MLX

**Blockers** : Aucun

---

### 📋 To Do

#### US-103 : Ajouter cible Makefile pour macMLX
- **Epic** : Epic 1 (macMLX Support)
- **Effort** : 2 points
- **Assigné** : Alex
- **Statut** : 📋 **To Do**

**Dépendances** : US-102 (script start-macmlx.sh doit exister)

---

#### US-201 : Implémenter bootstrap configuration multi-format
- **Epic** : Epic 2 (DevOps Patterns)
- **Effort** : 8 points
- **Assigné** : Alex
- **Statut** : 📋 **To Do**

**Tâches** :
- [ ] Créer `scripts/config-bootstrap.sh`
- [ ] Parser `.env` et générer `env.sh`, `env.docker`, `env.mk`
- [ ] Gérer `.env.user` pour overrides locaux
- [ ] Tests avec différents fichiers .env

**Notes** : Suivre ADR-600 (configuration management)

---

#### US-202 : Créer Makefile orchestrateur principal
- **Epic** : Epic 2 (DevOps Patterns)
- **Effort** : 8 points
- **Assigné** : Alex
- **Statut** : 📋 **To Do**

**Tâches** :
- [ ] Créer `Makefile` avec cibles standard
- [ ] Implémenter : `setup`, `config`, `start`, `stop`, `test`, `clean`
- [ ] Gestion dépendances (`start` → `config`)
- [ ] Aide intégrée `make help`
- [ ] Couleurs ANSI (ADR-605)

**Notes** : Suivre ADR-602 (règle des 3 lignes)

---

#### US-203 : Standardiser nomenclature scripts existants
- **Epic** : Epic 2 (DevOps Patterns)
- **Effort** : 3 points
- **Assigné** : Alex
- **Statut** : 📋 **To Do**

**Tâches** :
- [ ] Audit scripts actuels (`scripts/`)
- [ ] Renommer selon pattern `{object}-{action}.sh` (ADR-601)
  - `start-ollama.sh` → `ollama-start.sh`
  - `start-litellm.sh` → `litellm-start.sh`
  - `start-local-agent.sh` → `local-agent-start.sh`
  - `check-local-endpoint.sh` → `local-endpoint-check.sh`
  - `check-public-endpoint.sh` → `public-endpoint-check.sh`
- [ ] Mettre à jour références dans Makefile et documentation
- [ ] Tests après renommage
- [ ] Créer `scripts/README.md`

**Notes** : Suivre ADR-601 (pattern `{object}-{action}`).

---

## 📝 Daily Notes

### 2026-06-05 (Jour 1 — Jeudi)

**Hier** : N/A (début de sprint)

**Aujourd'hui** :
- ✅ Complété US-101 (documentation macMLX)
- ✅ Créé structure Scrum (personas, product-backlog, current-sprint)
- ✅ Réorganisé structure documentation (Divio System)
- ✅ Créé ADR-001 (Adoption Scrum)
- 🚧 Commencé réflexion US-102 (script start-macmlx.sh)

**Blockers** : Aucun

**Notes** :
- Documentation macMLX plus complète que prévu (benchmark inclus)
- Architecture overview mise à jour avec choix runtime
- Commit `7b0223a` : réorganisation docs + ADR-001

---

### 2026-06-06 (Jour 2 — Vendredi)

**Hier** :
- [Compléter après la journée]

**Aujourd'hui** :
- [Compléter en début de journée]

**Blockers** :
- [Identifier les blockers]

**Notes** :
- [Notes diverses]

---

### 2026-06-09 (Jour 3 — Lundi)

**Hier** : [Weekend]

**Aujourd'hui** :
- [Compléter en début de journée]

**Blockers** :
- [Identifier les blockers]

---

### 2026-06-10 (Jour 4 — Mardi)

**Hier** :
- [Compléter après la journée]

**Aujourd'hui** :
- [Compléter en début de journée]

**Blockers** :
- [Identifier les blockers]

---

### 2026-06-11 (Jour 5 — Mercredi)

**Hier** :
- [Compléter après la journée]

**Aujourd'hui** :
- [Compléter en début de journée]

**Blockers** :
- [Identifier les blockers]

---

### 2026-06-12 (Jour 6 — Jeudi)

**Hier** :
- [Compléter après la journée]

**Aujourd'hui** :
- [Compléter en début de journée]

**Blockers** :
- [Identifier les blockers]

---

### 2026-06-13 (Jour 7 — Vendredi)

**Hier** :
- [Compléter après la journée]

**Aujourd'hui** :
- [Compléter en début de journée]

**Blockers** :
- [Identifier les blockers]

---

### 2026-06-16 (Jour 8 — Lundi)

**Hier** : [Weekend]

**Aujourd'hui** :
- [Compléter en début de journée]

**Blockers** :
- [Identifier les blockers]

---

### 2026-06-17 (Jour 9 — Mardi)

**Hier** :
- [Compléter après la journée]

**Aujourd'hui** :
- [Compléter en début de journée]

**Blockers** :
- [Identifier les blockers]

---

### 2026-06-18 (Jour 10 — Mercredi)

**Hier** :
- [Compléter après la journée]

**Aujourd'hui** :
- [Compléter en début de journée]
- Préparer Sprint Review

**Blockers** :
- [Identifier les blockers]

---

## 📊 Burndown Chart (Manuel)

| Jour | Date | Points Restants | Stories Complétées | Notes |
|------|------|-----------------|-------------------|-------|
| 0 | 2026-06-05 | 19 | 0/6 | Sprint Planning |
| 1 | 2026-06-05 | 17 | 1/6 | US-101 complété |
| 2 | 2026-06-06 | ? | ?/6 | [À remplir] |
| 3 | 2026-06-09 | ? | ?/6 | [À remplir] |
| 4 | 2026-06-10 | ? | ?/6 | [À remplir] |
| 5 | 2026-06-11 | ? | ?/6 | [À remplir] |
| 6 | 2026-06-12 | ? | ?/6 | [À remplir] |
| 7 | 2026-06-13 | ? | ?/6 | [À remplir] |
| 8 | 2026-06-16 | ? | ?/6 | [À remplir] |
| 9 | 2026-06-17 | ? | ?/6 | [À remplir] |
| 10 | 2026-06-18 | 0 | 6/6 | **Sprint Review** |

---

## ✅ Sprint Review (2026-06-19)

**Participants** : [À remplir]

### Démonstration

**User Stories complétées** : [X/6]

1. **US-101** : Documentation macMLX ✅
   - Demo : Parcours de la documentation, comparaison Ollama vs macMLX
   - Feedback : [À remplir après review]

2. **US-102** : Script start-macmlx.sh
   - Demo : [À remplir]
   - Feedback : [À remplir]

3. **US-103** : Cibles Makefile macMLX
   - Demo : [À remplir]
   - Feedback : [À remplir]

4. **US-201** : Bootstrap configuration
   - Demo : [À remplir]
   - Feedback : [À remplir]

5. **US-202** : Makefile orchestrateur
   - Demo : [À remplir]
   - Feedback : [À remplir]

6. **US-203** : Nomenclature scripts
   - Demo : [À remplir]
   - Feedback : [À remplir]

### Métriques

| Métrique | Valeur |
|----------|--------|
| **Stories planifiées** | 6 |
| **Stories complétées** | ? |
| **Points planifiés** | 19 |
| **Points complétés** | ? |
| **Vélocité** | ? points/sprint |
| **Taux de complétion** | ?% |

### Feedback Utilisateur

[À remplir : retours des personas, utilisateurs externes]

---

## 🔄 Sprint Retrospective (2026-06-19)

**Participants** : [À remplir]

### Start (Commencer à faire)

- [À remplir après retrospective]

### Stop (Arrêter de faire)

- [À remplir après retrospective]

### Continue (Continuer à faire)

- ✅ Documentation complète avant implémentation (US-101 bien documenté)
- [À remplir après retrospective]

### Actions d'Amélioration

| Action | Responsable | Deadline |
|--------|-------------|----------|
| [À définir] | [Nom] | [Date] |

---

## 📈 Insights & Learnings

### Points Positifs

- [À remplir en fin de sprint]

### Points d'Amélioration

- [À remplir en fin de sprint]

### Décisions Techniques

- [Documenter les décisions importantes prises pendant le sprint]
- [Si décision architecturale majeure → créer ADR]

---

_Sprint créé le : 2026-06-05_  
_Dernière mise à jour : 2026-06-05_
