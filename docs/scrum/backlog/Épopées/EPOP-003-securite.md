# EPOP-003 : Security Hardening

**Type** : Épopée  
**ID** : EPOP-003  
**Statut** : 📋 To Do  
**Sprint** : Sprint 2

---

## 📋 Vue d'Ensemble

**Objectif** : Sécuriser le gateway selon [docs/reference/security.md](../../../reference/security.md)

**Valeur Métier** : Réduction des risques d'exposition/breach avant mise en production

**Personas Concernés** :
- 🔴 Riley (Security) — Critique
- 🟡 Jordan (DevOps) — Important

---

## 🎯 Objectifs

1. Intégrer Azure Key Vault pour gestion des secrets
2. Implémenter log redaction (prompts, API keys)
3. Ajouter rate limiting au proxy Azure
4. Créer threat model diagram

---

## 📊 Métriques de Succès

| Métrique | Cible | Actuel |
|----------|-------|--------|
| **Secrets hardcodés** | 0 | 📊 À auditer |
| **Log redaction coverage** | 100% | 0% |
| **Security tests passed** | 100% | 🚧 À implémenter |

---

## 🗂️ Récits Utilisateurs

| ID | Récit | Priorité | Effort | Statut |
|----|-------|----------|--------|--------|
| [RECIT-301](../Récits/RECIT-301-azure-key-vault.md) | Azure Key Vault | Must Have | 8 pts | 📋 To Do |
| [RECIT-302](../Récits/RECIT-302-log-redaction.md) | Log redaction | Must Have | 5 pts | 📋 To Do |
| [RECIT-303](../Récits/RECIT-303-rate-limiting.md) | Rate limiting | Must Have | 5 pts | 📋 To Do |
| [RECIT-304](../Récits/RECIT-304-threat-model.md) | Threat model diagram | Should Have | 5 pts | 📋 To Do |

**Total** : 4 récits, 23 points

---

## 📈 Progression

```
Progress: ░░░░░░░░░░░░░░░░░░░░ 0% (0/4 récits)
Points:   ░░░░░░░░░░░░░░░░░░░░ 0% (0/23 points)
```

**Récits complétés** : 0/4 (0%)  
**Points complétés** : 0/23 (0%)

---

## 🔗 Dépendances

### Dépendances Externes
- ☁️ Azure Subscription active
- 🔑 Azure Key Vault provisionné
- 🌐 Azure HTTPS proxy déployé (EPOP-004)

### Dépendances Internes
- 🛠️ EPOP-002 complété (config system pour secrets)
- 📄 RECIT-504 (Logs JSON) pour redaction efficace
- 🌐 RECIT-402 (Proxy Azure) pour rate limiting

---

## ⚠️ Risques Identifiés

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| Proxy non déployé | Élevée | Bloquant | RECIT-303 conditionnel |
| Rotation secrets complexe | Moyenne | Moyen | Documenter process |
| Regex redaction incomplet | Moyenne | Élevé | Tests exhaustifs |

---

## 🎓 Learnings et Décisions

### Décisions Architecturales
- **Key Vault = Source de Vérité** : Aucun secret dans code/config
- **Managed Identity** : Agent relay utilise MI pour Key Vault
- **Redaction dès logging** : Pas de secrets en mémoire logs

### Security Baseline (docs/reference/security.md)
✅ Requis:
- HTTPS strict (TLS 1.2+)
- Auth proxy (API keys / OAuth)
- Localhost-only pour Ollama/macMLX
- Pas d'exposition directe LLM

🚧 À implémenter:
- Rate limiting
- Log redaction
- Key Vault integration
- Certificate lifecycle

---

## 📅 Timeline

| Phase | Début | Fin | Statut |
|-------|-------|-----|--------|
| **Key Vault** | 2026-06-20 | 2026-06-24 | 📋 Sprint 2 |
| **Log Redaction** | 2026-06-23 | 2026-06-26 | 📋 Sprint 2 |
| **Rate Limiting** | 2026-06-27 | 2026-07-01 | 📋 Sprint 2 |
| **Threat Model** | 2026-07-04 | 2026-07-08 | 📋 Sprint 3 |

---

## 🔄 Historique

| Date | Action | Auteur |
|------|--------|--------|
| 2026-06-05 | Création épopée | Alex |
| 2026-06-05 | Baseline security.md existant | Alex |

---

_Dernière mise à jour : 2026-06-05_
