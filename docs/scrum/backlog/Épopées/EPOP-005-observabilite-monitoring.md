# EPOP-005 : Observabilité et Monitoring

**Type** : Épopée  
**ID** : EPOP-005  
**Statut** : 📋 To Do  
**Sprint** : Sprint 2-3

---

## 📋 Vue d'Ensemble

**Objectif** : Monitorer la santé et les performances du gateway

**Valeur Métier** : Réduction MTTR (Mean Time To Recovery)

**Personas Concernés** :
- 🟡 Jordan (DevOps) — Important
- 🟡 Alex (Développeur) — Important

---

## 🎯 Objectifs

1. Intégrer Application Insights pour métriques Azure
2. Ajouter health checks endpoints
3. Créer dashboard Grafana (optionnel)
4. Implémenter logs structurés JSON

---

## 📊 Métriques de Succès

| Métrique | Cible | Actuel |
|----------|-------|--------|
| **MTTR** | <30 minutes | 📊 Baseline à établir |
| **Uptime** | ≥99.5% | 📊 Non mesuré |
| **Log coverage** | 100% JSON | 0% |

---

## 🗂️ Récits Utilisateurs

| ID | Récit | Priorité | Effort | Statut |
|----|-------|----------|--------|--------|
| [RECIT-501](../Récits/RECIT-501-application-insights.md) | Application Insights | Must Have | 8 pts | 📋 To Do |
| [RECIT-502](../Récits/RECIT-502-health-checks.md) | Health checks endpoints | Must Have | 5 pts | 📋 To Do |
| [RECIT-503](../Récits/RECIT-503-grafana-dashboard.md) | Dashboard Grafana | Could Have | 13 pts | 📋 To Do |
| [RECIT-504](../Récits/RECIT-504-logs-json.md) | Logs structurés JSON | Should Have | 5 pts | 📋 To Do |

**Total** : 4 récits, 31 points

---

## 📈 Progression

```
Progress: ░░░░░░░░░░░░░░░░░░░░ 0% (0/4 récits)
Points:   ░░░░░░░░░░░░░░░░░░░░ 0% (0/31 points)
```

**Récits complétés** : 0/4 (0%)  
**Points complétés** : 0/31 (0%)

---

## 🔗 Dépendances

### Dépendances Externes
- ☁️ Azure Application Insights provisionné
- 🌐 Azure HTTPS proxy déployé (EPOP-004)
- 🐳 Docker (optionnel pour Grafana)

### Dépendances Internes
- 🛠️ EPOP-004 (IaC) pour déploiement Application Insights
- 🔐 RECIT-302 (Log redaction) pour logs sécurisés
- 🌐 RECIT-402 (Proxy) pour health checks proxy

---

## ⚠️ Risques Identifiés

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| App Insights coûteux | Moyenne | Moyen | Sampling 10% |
| Health checks flaky | Moyenne | Moyen | Retry logic |
| Grafana overhead | Faible | Faible | Optionnel |

---

## 🎓 Learnings et Décisions

### Décisions Architecturales
- **Application Insights = MVP** : Monitoring Azure-native
- **Health checks locaux** : Ne nécessitent pas proxy (avançable Sprint 2)
- **Grafana = Nice-to-have** : Uniquement si demande utilisateur

### Métriques Clés À Monitorer
- **Latence** : P50, P95, P99 des requêtes LLM
- **Throughput** : Requêtes/sec, tokens/sec
- **Erreurs** : Taux d'erreur 5xx, timeouts
- **Availability** : Uptime Relay, Ollama/macMLX, Proxy

---

## 📅 Timeline

| Phase | Début | Fin | Statut |
|-------|-------|-----|--------|
| **Health Checks** | 2026-06-25 | 2026-06-27 | 📋 Sprint 2 |
| **Logs JSON** | 2026-07-04 | 2026-07-08 | 📋 Sprint 3 |
| **App Insights** | 2026-07-09 | 2026-07-15 | 📋 Sprint 3 |
| **Grafana** | 2026-07-18 | 2026-07-31 | 📋 Sprint 4 |

---

## 🔄 Historique

| Date | Action | Auteur |
|------|--------|--------|
| 2026-06-05 | Création épopée | Alex |

---

_Dernière mise à jour : 2026-06-05_
