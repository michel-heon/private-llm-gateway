---
# 🤖 Machine-Readable Metadata (Frontmatter YAML)
# Permet parsing automatique par agents IA et recherche/filtrage avancé

adr: 001
title: "Adoption de Scrum pour la gestion du projet Private LLM Gateway"
status: "accepted"
date: 2026-06-05
superseded_by: null
replaces: null
related_adrs: [000]  # Processus de création ADR
related_issues: []

# 🗂️ Taxonomie ADR (Voir TAXONOMY.md pour détails complets)
classification:
  lifecycle: "accepted"
  domain: "META"
  impact: "medium"
  
  # Quality Attributes (ASR): Qualités système affectées
  quality:
    - "maintainability"    # organisation du travail, traçabilité
    - "usability"          # collaboration, transparence
    - "compliance"         # processus documenté, auditabilité
  
  reversibility: "easy"     # Changement de méthodologie possible
  scope: "strategic"        # Définit la façon de travailler
  
  tech_areas:
    - "project-management"
    - "agile"
    - "scrum"
    - "documentation"

tags: ["scrum", "agile", "process", "methodology", "collaboration"]

stakeholders: ["@project-team", "@product-owner", "@scrum-master"]

effort: "low"  # L'adoption initiale est légère
---

# ADR 001: Adoption de Scrum pour la gestion du projet Private LLM Gateway

## 📊 Vue d'Ensemble

| Attribut | Valeur |
|----------|--------|
| **Statut** | ✅ Accepté |
| **Date Décision** | 2026-06-05 |
| **Stakeholders** | @project-team, @product-owner |
| **Impact** | 🟡 Moyen |
| **Effort Implémentation** | 🟢 Faible |
| **Risque Technique** | 🟢 Faible |

---

## 🎯 Contexte & Problème

### Situation Actuelle

Le projet **Private LLM Gateway** est un système permettant d'exposer des LLMs locaux (Ollama, macMLX) via Azure Relay comme endpoint HTTPS compatible OpenAI. Le projet comporte plusieurs dimensions :

- **Infrastructure** : Azure Relay, Azure HTTPS proxy, réseau hybride
- **Runtime** : Ollama vs macMLX, LiteLLM gateway
- **DevOps** : scripts, Makefile, configuration multi-format
- **Documentation** : ADRs, guides techniques, architecture

### Problème

Sans méthodologie de gestion structurée, le projet risque :

1. **Manque de priorisation** : difficulté à choisir les prochaines fonctionnalités
2. **Faible visibilité** : progression non mesurable, TODOs éparpillés
3. **Documentation déconnectée** : ADRs créés sans lien avec les implémentations
4. **Livraisons irrégulières** : pas de rythme de release établi
5. **Feedback tardif** : validation utilisateur en fin de cycle seulement

### Contraintes

- **Équipe petite** : 1-3 personnes (contexte solo/open-source possible)
- **Temps partiel** : contributions non continues
- **Open source** : contributeurs externes potentiels
- **Complexité technique** : Azure, Python, networking, LLM runtimes

---

## ✅ Décision

**Nous adoptons une version allégée de Scrum** adaptée à la taille et au contexte du projet, avec les adaptations suivantes :

### Framework Scrum Appliqué

#### 1. Sprints de 2 semaines
- Durée fixe : **2 semaines** (compromis entre fréquence et overhead)
- Planning le lundi semaine 1, Review + Retro le vendredi semaine 2
- Livraison d'un **increment potentiellement shippable** à chaque fin de sprint

#### 2. Rôles (adaptés)
- **Product Owner** : Définit la vision, priorise le Product Backlog
- **Development Team** : 1-3 personnes (peut être la même personne en solo)
- **Scrum Master** : Facilite le processus (peut être partagé avec dev en petit groupe)

#### 3. Artefacts

##### Product Backlog
- User stories au format : `En tant que [utilisateur], je veux [fonctionnalité], afin de [bénéfice]`
- Priorisation par valeur métier vs effort (MoSCoW : Must, Should, Could, Won't)
- Stocké dans **GitHub Issues** avec labels `user-story`, `epic`, `sprint-X`

##### Sprint Backlog
- Sous-tâches extraites du Product Backlog
- Trackées dans **GitHub Projects** (Kanban board)
- États : `To Do` → `In Progress` → `In Review` → `Done`

##### Definition of Done (DoD)
```markdown
✅ Code écrit et testé localement
✅ Documentation à jour (README, ADR si applicable)
✅ Pas de TODO bloquant laissé dans le code
✅ Commit conventionnel (feat/fix/docs/refactor)
✅ Push sur GitHub, PR reviewée (si multi-personnes)
```

#### 4. Cérémonies (allégées)

| Cérémonie | Durée | Fréquence | Format |
|-----------|-------|-----------|--------|
| **Sprint Planning** | 1h | Début de sprint | Sélection user stories → décomposition en tâches |
| **Daily Scrum** | 15min | Chaque jour *(async possible)* | 3 questions : Hier? Aujourd'hui? Blocages? |
| **Sprint Review** | 30min | Fin de sprint | Demo de l'increment + collecte feedback |
| **Sprint Retrospective** | 30min | Fin de sprint | Start/Stop/Continue + actions d'amélioration |

**Adaptation solo/petite équipe** :
- Daily Scrum → log quotidien dans un fichier `docs/sprints/sprint-N/daily.md`
- Review → auto-évaluation + validation utilisateur externe si disponible
- Retro → réflexion personnelle documentée

---

## 🏗️ Conséquences

### ✅ Avantages

1. **Priorisation claire** : backlog ordonné par valeur métier
2. **Rythme prévisible** : release toutes les 2 semaines
3. **Feedback rapide** : validation incrémentale des fonctionnalités
4. **Traçabilité** : lien user story → commit → ADR → release
5. **Amélioration continue** : retrospectives identifient les frictions
6. **Documentation vivante** : ADRs créés au moment des décisions techniques
7. **Compatibilité open-source** : GitHub Issues/Projects = outils standards

### ⚠️ Inconvénients & Risques

1. **Overhead cérémoniel** : peut sembler lourd en mode solo (mitigé par adaptation)
2. **Discipline requise** : nécessite rigueur dans le suivi quotidien
3. **Rigidité des sprints** : peut frustrer si une tâche dépasse (solution : buffer de 20%)
4. **Dépendance aux outils** : GitHub Issues/Projects requis

### 📈 Métriques de Succès

| Métrique | Cible | Mesure |
|----------|-------|--------|
| **Vélocité stable** | ±20% entre sprints | Story points complétés / sprint |
| **Taux de complétion sprint** | ≥80% | Stories Done / Stories planifiées |
| **Fréquence de release** | Toutes les 2 semaines | Commits taguées `vX.Y.Z` |
| **Qualité ADR** | 1 ADR / décision majeure | Nombre ADRs créés dans le sprint |
| **Time-to-feedback** | <2 semaines | Délai user story → validation |

---

## 🔄 Alternatives Considérées

### Option A: Kanban pur (sans sprints)
- ✅ **Avantages** : Flux continu, moins de cérémonie, adaptabilité maximale
- ❌ **Inconvénients** : Pas de rythme de release, manque de points de feedback réguliers
- **Rejet** : Besoin de cadence prévisible pour les releases

### Option B: Waterfall / Cascade
- ✅ **Avantages** : Planning exhaustif upfront, moins de réunions
- ❌ **Inconvénients** : Rigidité, feedback tardif, inadapté à l'innovation technique
- **Rejet** : Trop rigide pour un projet d'infrastructure cloud/LLM en évolution

### Option C: Scrum complet (sans adaptation)
- ✅ **Avantages** : Framework éprouvé, documentation abondante
- ❌ **Inconvénients** : Overhead trop élevé pour 1-3 personnes, cérémonies lourdes
- **Rejet** : Besoin d'alléger pour contexte petite équipe

### Option D: Aucune méthodologie (ad hoc)
- ✅ **Avantages** : Zéro overhead, liberté totale
- ❌ **Inconvénients** : Désorganisation, perte de focus, pas de traçabilité
- **Rejet** : Risque de dispersion sur un projet multi-composants

---

## 📚 Ressources & Références

- [Scrum Guide officiel](https://scrumguides.org/) (Schwaber & Sutherland)
- [GitHub Projects pour Scrum](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [ADR 000 - Processus de création ADR](./000-META-processus-creation-adr.md) (cohérence avec sprints)
- [Conventional Commits](https://www.conventionalcommits.org/) (standard de commit)

---

## 📝 Notes d'Implémentation

### Structure du backlog GitHub

```markdown
Epic : Ajouter support macMLX comme alternative à Ollama
├── User Story 1 : En tant qu'utilisateur Mac M1, je veux utiliser macMLX pour des inférences 2x plus rapides
│   ├── Tâche 1.1 : Documenter installation macMLX
│   ├── Tâche 1.2 : Adapter config LiteLLM pour port 8080
│   └── Tâche 1.3 : Créer ADR comparant Ollama vs macMLX
├── User Story 2 : En tant que développeur, je veux un script de démarrage unifié
│   ├── Tâche 2.1 : Créer start-macmlx.sh
│   └── Tâche 2.2 : Ajouter cible `make macmlx-start`
└── Acceptance Criteria :
    - LiteLLM peut router vers macMLX sur :8080
    - Documentation claire dans docs/guides/setup/litellm-ollama.md
    - Script shell testable avec --dry-run
```

### Labels GitHub recommandés

- `epic` : Fonctionnalité haute-niveau (multi-sprints)
- `user-story` : Story utilisateur atomique (1 sprint)
- `sprint-1`, `sprint-2`, ... : Assignation sprint
- `must-have`, `should-have`, `could-have`, `wont-have` : Priorité MoSCoW
- `adr-required` : Nécessite une décision architecturale documentée

### Fichier de suivi du sprint (optionnel)

```
docs/sprints/
├── sprint-1/
│   ├── planning.md         # User stories sélectionnées + estimations
│   ├── daily.md            # Log quotidien (async)
│   ├── review.md           # Demo + feedback
│   └── retrospective.md    # Start/Stop/Continue + actions
└── sprint-2/
    └── ...
```

---

## 🔗 Liens avec Autres ADRs

- **ADR 000** : Ce processus de création ADR s'intègre dans les sprints (1 ADR par décision technique)
- **ADR 600-607** : Les décisions DevOps seront priorisées dans le Product Backlog
- **Futurs ADRs** : Chaque décision technique fera l'objet d'un ADR créé pendant le sprint

---

## ✍️ Historique des Modifications

| Date | Auteur | Modification |
|------|--------|--------------|
| 2026-06-05 | @michelheon | Création initiale - adoption Scrum allégé |

---

## 💡 Questions & Actions Ouvertes

- [ ] Créer GitHub Project "Private LLM Gateway Backlog"
- [ ] Définir les premiers epics du Product Backlog
- [ ] Planifier Sprint 1 (date de début)
- [ ] Configurer labels GitHub recommandés
- [ ] Décider si utilisation de story points ou t-shirt sizing (XS/S/M/L/XL)
