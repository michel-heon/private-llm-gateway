# Backlog Prioritization — Décisions et Rationale

Documentation des décisions de priorisation du Product Backlog.

---

## 📊 Vue d'Ensemble

**Dernière priorisation** : 2026-06-05  
**Prochaine réévaluation** : 2026-06-19 (fin Sprint 1)  
**Méthode** : MoSCoW (Must/Should/Could/Won't)

---

## 🎯 Critères de Priorisation

### 1. Valeur Métier (Business Value)

| Score | Description | Exemples |
|-------|-------------|----------|
| **5** | Bloquant pour MVP | Support macMLX (2x speedup), Configuration bootstrap |
| **4** | Important pour adoption | Makefile orchestrateur, Scripts standardisés |
| **3** | Nice-to-have pour UX | Couleurs ANSI, Health checks |
| **2** | Amélioration long-terme | Grafana dashboard, Terraform alternative |
| **1** | Expérimental/R&D | Dual runtime auto-switch |

### 2. Risque Technique (Risk)

| Score | Description | Exemples |
|-------|-------------|----------|
| **5** | Risque élevé, nécessite POC | IaC Azure (Bicep templates) |
| **4** | Complexité moyenne | Configuration multi-format, Rate limiting |
| **3** | Faible risque | Scripts bash standard |
| **2** | Bien maîtrisé | Documentation, Renommage fichiers |
| **1** | Trivial | Ajout couleurs logs |

### 3. Dépendances (Dependencies)

| Type | Description | Impact Priorisation |
|------|-------------|---------------------|
| **Hard Dependency** | Bloquant absolu (ex: config avant Makefile) | **Priorité +2** |
| **Soft Dependency** | Préférable mais contournable | **Priorité +1** |
| **Optional** | Aucune dépendance critique | **Priorité neutre** |

### 4. Effort (Story Points)

| Points | Durée Estimée | Priorisation |
|--------|---------------|--------------|
| **1-3** | 1-2 jours | **Quick wins** : prioriser pour momentum |
| **5-8** | 3-5 jours | **Cœur de sprint** : 2-3 stories/sprint |
| **13+** | 1-2 semaines | **À découper** en sub-stories |

---

## 🔄 Historique des Décisions

### 2026-06-05 : Sprint 1 Planning — Priorisation Initiale

**Contexte** :
- Sprint 1 est le premier sprint post-création documentation
- US-101 (documentation macMLX) déjà complétée
- Besoin de fondations solides avant security/IaC

**Décisions** :

#### ✅ Inclus dans Sprint 1 (19 points)

1. **US-102, US-103** (macMLX scripts + Make) — **Must Have**
   - **Rationale** : Compléter Epic 1, valeur immédiate pour utilisateurs Mac
   - **Valeur Métier** : 5/5 (2x speedup démontrable)
   - **Risque** : 2/5 (bash standard)
   - **Effort** : 5 points total

2. **US-201** (Bootstrap configuration) — **Must Have**
   - **Rationale** : Fondation pour tous les autres scripts/Make
   - **Valeur Métier** : 5/5 (bloquant pour MVP)
   - **Risque** : 4/5 (parsing .env, génération multi-format)
   - **Effort** : 8 points
   - **Dépendance** : Hard dependency pour US-202

3. **US-202** (Makefile orchestrateur) — **Must Have**
   - **Rationale** : UX principale pour développeurs
   - **Valeur Métier** : 5/5 (interface unique)
   - **Risque** : 3/5 (Makefile bien connu)
   - **Effort** : 8 points
   - **Dépendance** : Nécessite US-201 complétée

4. **US-203** (Nomenclature scripts) — **Should Have**
   - **Rationale** : Quick win pour cohérence, préalable à ADR-607
   - **Valeur Métier** : 3/5 (UX consistency)
   - **Risque** : 2/5 (renommage + tests)
   - **Effort** : 3 points

#### ❌ Repoussé à Sprint 2+

1. **US-104** (Dual runtime switch) — **Could Have** → Sprint 2
   - **Rationale** : Nice-to-have, complexité moyenne (5 pts), pas critique
   - **Décision** : Attendre feedback utilisateurs sur macMLX vs Ollama

2. **US-204** (Couleurs ANSI) — **Should Have** → Sprint 2
   - **Rationale** : UX improvement, non bloquant
   - **Décision** : Implémenter après Makefile de base existe

3. **US-205** (Parsing options Bash) — **Should Have** → Sprint 2
   - **Rationale** : Amélioration post-MVP, 5 points
   - **Décision** : Appliquer après scripts de base fonctionnels

4. **Epic 3 (Security)** → Sprint 2
   - **Rationale** : Nécessite infrastructure stable (US-201, US-202 complétées)
   - **Décision** : Security hardening après fondations DevOps

5. **Epic 4 (IaC)** → Sprint 3
   - **Rationale** : Risque élevé (5/5), effort important (21 pts Must Have)
   - **Décision** : Attendre vélocité confirmée après Sprint 1-2

6. **Epic 5 (Monitoring)** → Sprint 3
   - **Rationale** : Dépend de déploiement Azure (Epic 4)
   - **Décision** : Application Insights nécessite proxy Azure déployé

---

### Futures Réévaluations Planifiées

#### Sprint Review 1 (2026-06-19)

**Questions à poser** :
- [ ] Vélocité réelle vs estimée (19 points planifiés) ?
- [ ] Feedback utilisateurs sur macMLX (performance réelle) ?
- [ ] Besoin de dual runtime switch (US-104) validé ?
- [ ] Blockers identifiés pour Epic 3 (Security) ?

**Actions possibles** :
- Ajuster capacité Sprint 2 selon vélocité Sprint 1
- Re-prioriser Epic 3 vs Epic 4 si security devient urgente
- Découper US-201/US-202 si sous-estimées

---

## 🧮 Matrice de Priorisation

### Eisenhower Matrix Appliquée

```
                        Urgent
                          |
  ┌─────────────────────┬─────────────────────┐
  │                     │                     │
  │   US-201, US-202    │   US-102, US-103    │
  │   (Config + Make)   │   (macMLX scripts)  │
I │                     │                     │
m │   Must Have         │   Must Have         │
p │   Sprint 1          │   Sprint 1          │
o │                     │                     │
r ├─────────────────────┼─────────────────────┤
t │                     │                     │
a │   Epic 4 (IaC)      │   US-203            │
n │   US-401, US-402    │   (Nomenclature)    │
t │                     │                     │
  │   Must Have         │   Should Have       │
  │   Sprint 3          │   Sprint 1          │
  │                     │                     │
  └─────────────────────┴─────────────────────┘
                     Pas Urgent
```

**Quadrant 1 (Urgent + Important)** : US-102, US-103 — Compléter macMLX NOW  
**Quadrant 2 (Important mais pas urgent)** : US-201, US-202 — Fondations critiques  
**Quadrant 3 (Urgent mais moins important)** : US-203 — Quick win consistency  
**Quadrant 4 (Ni urgent ni important)** : US-104, Grafana dashboard — Backlog futur

---

## 📝 Notes de Priorisation par Epic

### Epic 1 : macMLX Support

**Statut** : 🟢 Priorité Max (Sprint 1)

**Rationale** :
- Documentation déjà complétée (US-101) ✅
- Momentum à maintenir pour valeur immédiate
- Utilisateurs Mac (Alex, Sam) bloqués sans scripts

**Décisions** :
- US-102 + US-103 : Sprint 1 (Quick wins, 5 points total)
- US-104 : Repoussé Sprint 2 (complexité vs valeur)

---

### Epic 2 : DevOps Patterns

**Statut** : 🟡 Priorité Haute (Sprint 1-2)

**Rationale** :
- Fondation pour tous les autres epics
- ADRs 600-607 déjà documentés, besoin d'implémentation
- US-201 (config) est hard dependency pour US-202 (Make)

**Décisions** :
- US-201 + US-202 : Sprint 1 (16 points, cœur de sprint)
- US-203 : Sprint 1 (Quick win, 3 points)
- US-204 + US-205 : Sprint 2 (11 points, améliorations UX)

**Risques identifiés** :
- ⚠️ US-201 peut être sous-estimée (parsing .env complexe)
- ⚠️ US-202 dépend de US-201, risque cascade

**Mitigation** :
- Commencer US-201 dès fin US-102
- Si dépassement, découper US-202 en sub-stories

---

### Epic 3 : Security

**Statut** : 🟡 Priorité Haute (Sprint 2)

**Rationale** :
- Must Have pour production (US-301, US-302, US-303)
- Nécessite infrastructure stable (Epic 2 complété)
- Riley (Security Engineer) bloquée sans fondations

**Décisions** :
- Tout Epic 3 repoussé à Sprint 2
- 18 points Must Have à prioriser absolument Sprint 2

**Dépendances** :
- US-301 (Key Vault) nécessite Azure CLI configuré
- US-302 (Log redaction) nécessite logs structurés (US-504)
- US-303 (Rate limiting) nécessite proxy Azure (Epic 4)

**Actions** :
- [ ] Valider si US-303 doit attendre Epic 4 ou si implémentation locale possible
- [ ] Préparer POC Key Vault integration avant Sprint 2

---

### Epic 4 : IaC

**Statut** : 🔴 Priorité Moyenne (Sprint 3)

**Rationale** :
- Risque technique élevé (5/5)
- Effort important (42 points total)
- Nécessite expertise Azure Bicep/Terraform

**Décisions** :
- Epic 4 repoussé à Sprint 3 minimum
- US-401 + US-402 (Bicep templates) : Must Have Sprint 3
- US-403 (GitHub Actions) : Should Have Sprint 3
- US-404 (Terraform) : Could Have Sprint 4+

**Risques identifiés** :
- ⚠️ Manque d'expérience Bicep dans l'équipe
- ⚠️ Dépendance à subscription Azure test

**Mitigation** :
- Allouer temps POC Bicep fin Sprint 2
- Considérer tutorial Azure Bicep avant Sprint 3
- Alternative : Utiliser `azd` templates si Bicep trop complexe

---

### Epic 5 : Monitoring

**Statut** : 🔴 Priorité Moyenne (Sprint 3)

**Rationale** :
- Important pour production, mais pas bloquant MVP
- Dépend de déploiement Azure (Epic 4)
- US-502 (Health checks) peut être avancé Sprint 2

**Décisions** :
- US-501 (App Insights) : Sprint 3 (nécessite proxy Azure)
- US-502 (Health checks) : **Réévalué Sprint 2** (local possible)
- US-503 (Grafana) : Sprint 4+ (Could Have)
- US-504 (Logs JSON) : Sprint 3 (Should Have)

**Actions** :
- [ ] Valider si US-502 peut être implémenté localement sans Azure
- [ ] Si oui, avancer US-502 en Sprint 2 (synergy avec US-302)

---

## 🔄 Règles de Re-Priorisation

### Triggers de Re-Priorisation

1. **Feedback utilisateur critique** : Si un persona rapporte un blocage majeur → escalader en Must Have
2. **Découverte de dépendance technique** : Si US-X nécessite US-Y → réordonner
3. **Vélocité < 80% de l'estimation** : Réduire scope sprint suivant
4. **Vélocité > 120% de l'estimation** : Ajouter Should Have au sprint suivant
5. **Changement de contexte métier** : Ex: deadline externe → re-prioriser Epic concerné

### Process de Re-Priorisation

1. **Identifier le trigger** : Documenter la raison du changement
2. **Évaluer l'impact** : Stories affectées, sprints concernés
3. **Consulter personas** : Valider avec utilisateurs impactés
4. **Mettre à jour backlog** : Modifier `product-backlog.md`
5. **Documenter ici** : Ajouter entrée dans historique des décisions
6. **Communiquer** : Slack/mail si multi-personne, commit message si solo

---

## 📌 Décisions Architecturales Liées

Certaines décisions de priorisation découlent d'ADRs existants :

| ADR | Impact Priorisation | Stories Affectées |
|-----|---------------------|-------------------|
| **ADR-001** (Scrum) | Structure sprints 2 semaines | Toutes stories |
| **ADR-600** (Config) | US-201 doit précéder US-202 | US-201, US-202 |
| **ADR-601** (Nomenclature) | US-203 avant US-205 (parsing) | US-203, US-205 |
| **ADR-602** (Makefile) | US-202 bloquant pour UX | US-202 |

**Nouvelle ADR nécessaire ?**
- [ ] Si choix Bicep vs Terraform vs azd → créer ADR-200-INFRA-iac-tooling
- [ ] Si architecture monitoring finalisée → créer ADR-XXX-monitoring-strategy

---

## 📊 Métriques de Priorisation

### Distribution Must/Should/Could

| Priorité | Stories | Points | % Total |
|----------|---------|--------|---------|
| **Must Have** | 12 | 73 pts | 54% |
| **Should Have** | 7 | 34 pts | 25% |
| **Could Have** | 4 | 28 pts | 21% |
| **Won't Have** | 5 items | N/A | N/A |

**Objectif** : Must Have < 60% (✅ respecté)

### Distribution par Epic

| Epic | Must Have | Should Have | Could Have | Priorité Sprint |
|------|-----------|-------------|------------|-----------------|
| Epic 1 | 5 pts | 2 pts | 5 pts | Sprint 1 ✅ |
| Epic 2 | 16 pts | 11 pts | 0 pts | Sprint 1-2 ✅ |
| Epic 3 | 18 pts | 5 pts | 0 pts | Sprint 2 ⏳ |
| Epic 4 | 21 pts | 8 pts | 13 pts | Sprint 3 ⏳ |
| Epic 5 | 13 pts | 5 pts | 13 pts | Sprint 3 ⏳ |

---

## 🎯 OKRs et Alignement Backlog

### Q2 2026 (Avril-Juin)

**Objective** : Livrer un gateway LLM local fonctionnel et sécurisé

**Key Results** :
1. **KR1** : macMLX support complet avec benchmark (Epic 1) → **Sprint 1** ✅
2. **KR2** : Automatisation DevOps (Makefile + scripts) (Epic 2) → **Sprint 1-2** ⏳
3. **KR3** : Security baseline implémentée (Epic 3) → **Sprint 2** ⏳

**Alignement Backlog** :
- Sprint 1 adresse KR1 (100%) + KR2 (60%)
- Sprint 2 adresse KR2 (40%) + KR3 (100%)
- Sprint 3 adresse infrastructure (Epic 4, Epic 5)

---

## 📝 Notes Diverses

### Feedback Personas (à collecter)

- **Alex (Dev)** : [À compléter après Sprint 1 Review]
- **Jordan (DevOps)** : [À compléter après Sprint 1 Review]
- **Sam (User)** : [À compléter après Sprint 1 Review]
- **Riley (Security)** : [À compléter après Sprint 1 Review]

### Liens Utiles

- [Product Backlog complet](../product-backlog.md)
- [Sprint actuel](../sprints/current-sprint.md)
- [ADR-001 : Adoption Scrum](../../adr/001-META-adoption-scrum.md)
- [ADRs DevOps (600-607)](../../adr/)

---

_Dernière mise à jour : 2026-06-05_
