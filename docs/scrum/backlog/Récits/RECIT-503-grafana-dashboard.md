# RECIT-503 : Dashboard Grafana (optionnel)

**Type** : Récit Utilisateur  
**ID** : RECIT-503  
**Épopée** : [EPOP-005](../Épopées/EPOP-005-observabilite-monitoring.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** DevOps engineer  
**Je veux** un dashboard Grafana pour visualiser métriques  
**Afin de** avoir une vue unifiée hors Azure Portal

---

## ✅ Critères d'Acceptation

- [ ] Grafana déployé (Docker ou cloud)
- [ ] Datasource Application Insights configurée
- [ ] Dashboard avec panels : latence, throughput, erreurs
- [ ] Alerts Grafana (optionnel)

---

## 📊 Informations

**Priorité** : Could Have  
**Effort** : 13 points  
**Sprint** : Sprint 4  
**Assigné** : Jordan

---

## 🔗 Dépendances

- ✅ [RECIT-501](RECIT-501-application-insights.md) : Application Insights (source données)
- 🐳 Docker installé (si déploiement local)

---

## 📝 Setup Grafana

### 1. Déploiement Docker Compose

```yaml
# docker-compose.grafana.yml
version: '3.8'

services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana-llm-gateway
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_INSTALL_PLUGINS=grafana-azure-monitor-datasource
    volumes:
      - grafana-storage:/var/lib/grafana
      - ./grafana/dashboards:/etc/grafana/provisioning/dashboards
      - ./grafana/datasources:/etc/grafana/provisioning/datasources
    restart: unless-stopped

volumes:
  grafana-storage:
```

### 2. Datasource Application Insights

```yaml
# grafana/datasources/appinsights.yml
apiVersion: 1

datasources:
  - name: Azure Application Insights
    type: grafana-azure-monitor-datasource
    access: proxy
    jsonData:
      cloudName: azuremonitor
      subscriptionId: ${AZURE_SUBSCRIPTION_ID}
      tenantId: ${AZURE_TENANT_ID}
      clientId: ${AZURE_CLIENT_ID}
      appInsightsAppId: ${APPINSIGHTS_APP_ID}
    secureJsonData:
      clientSecret: ${AZURE_CLIENT_SECRET}
    editable: true
```

### 3. Dashboard JSON

```json
{
  "dashboard": {
    "title": "LLM Gateway Monitoring",
    "panels": [
      {
        "id": 1,
        "title": "Request Latency (P95)",
        "type": "graph",
        "targets": [
          {
            "refId": "A",
            "queryType": "Azure Log Analytics",
            "azureLogAnalytics": {
              "query": "customMetrics | where name == 'llm/request_latency' | summarize percentile(value, 95) by bin(timestamp, 5m)",
              "resource": "/subscriptions/.../resourceGroups/.../providers/microsoft.insights/components/..."
            }
          }
        ]
      },
      {
        "id": 2,
        "title": "Throughput (req/sec)",
        "type": "graph",
        "targets": [
          {
            "refId": "B",
            "queryType": "Azure Log Analytics",
            "azureLogAnalytics": {
              "query": "requests | summarize count() by bin(timestamp, 1m) | extend rps = count_ / 60"
            }
          }
        ]
      },
      {
        "id": 3,
        "title": "Error Rate",
        "type": "stat",
        "targets": [
          {
            "refId": "C",
            "queryType": "Azure Log Analytics",
            "azureLogAnalytics": {
              "query": "requests | summarize total = count(), errors = countif(success == false) | extend error_rate = (errors * 100.0) / total"
            }
          }
        ]
      }
    ]
  }
}
```

---

## 🧪 Tests

### Tests Fonctionnels

- [ ] Grafana accessible sur http://localhost:3000
- [ ] Datasource Azure connectée
- [ ] Dashboard affiche métriques en temps réel
- [ ] Panels se rafraîchissent automatiquement
- [ ] Filtres par environnement fonctionnels

### Tests Optionnels (Alerts)

- [ ] Alert si P95 latency > 2000ms
- [ ] Alert si error rate > 5%
- [ ] Notifications Slack/Teams (si configuré)

---

## 📋 Checklist Implémentation

### Setup

- [ ] Créer `docker-compose.grafana.yml`
- [ ] Créer répertoire `grafana/datasources/`
- [ ] Créer répertoire `grafana/dashboards/`
- [ ] Configurer datasource Application Insights
- [ ] Créer Service Principal Azure (read permissions)

### Dashboard

- [ ] Créer dashboard JSON
- [ ] Ajouter panel "Request Latency P95"
- [ ] Ajouter panel "Throughput"
- [ ] Ajouter panel "Error Rate"
- [ ] Ajouter panel "Uptime"
- [ ] Configurer auto-refresh (30s)

### Documentation

- [ ] Documenter déploiement Grafana
- [ ] Documenter configuration datasource
- [ ] Créer guide import dashboard
- [ ] Ajouter screenshots dans docs/

---

## 💡 Alternative : Azure Managed Grafana

```bash
# Créer instance Managed Grafana
az grafana create \
  --name "grafana-llm-gateway" \
  --resource-group "rg-llm-gateway" \
  --location canadacentral
```

**Avantages** :
- Haute disponibilité
- Pas de maintenance
- Intégration native Azure

**Inconvénients** :
- Coût (~100$/mois)
- Overkill pour projet personnel

---

_Dernière mise à jour : 2026-06-05_
