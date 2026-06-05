# RECIT-501 : Intégrer Application Insights

**Type** : Récit Utilisateur  
**ID** : RECIT-501  
**Épopée** : [EPOP-005](../Épopées/EPOP-005-observabilite-monitoring.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** DevOps engineer  
**Je veux** monitorer les métriques Azure avec Application Insights  
**Afin de** suivre performance et disponibilité

---

## ✅ Critères d'Acceptation

- [ ] Application Insights provisionné (Bicep ou CLI)
- [ ] Instrumentation Python SDK dans relay_agent.py
- [ ] Métriques custom : latence, throughput, erreurs
- [ ] Dashboard Azure Portal configuré

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 8 points  
**Sprint** : Sprint 3  
**Assigné** : Jordan

---

## 🔗 Dépendances

- ☁️ Azure Subscription
- 📄 [RECIT-402](RECIT-402-bicep-proxy.md) : Proxy déployé (pour collecter métriques)
- 📄 [RECIT-504](RECIT-504-logs-json.md) : Logs JSON (optionnel, mais recommandé)

---

## 📝 Instrumentation

### 1. Provisionner Application Insights (Bicep)

```bicep
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-llm-gateway-${environment}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    RetentionInDays: 90
    SamplingPercentage: 10  // 10% sampling pour coûts
  }
  
  tags: {
    Environment: environment
    Project: 'private-llm-gateway'
  }
}

output instrumentationKey string = appInsights.properties.InstrumentationKey
output connectionString string = appInsights.properties.ConnectionString
```

### 2. Instrumentation Python (relay_agent.py)

```python
from opencensus.ext.azure.log_exporter import AzureLogHandler
from opencensus.ext.azure.trace_exporter import AzureExporter
from opencensus.trace.samplers import ProbabilitySampler
from opencensus.trace.tracer import Tracer
import logging
import os

# Configuration
APPINSIGHTS_CONNECTION_STRING = os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING")

# Logging
logger = logging.getLogger(__name__)
logger.addHandler(AzureLogHandler(connection_string=APPINSIGHTS_CONNECTION_STRING))
logger.setLevel(logging.INFO)

# Tracing
tracer = Tracer(
    exporter=AzureExporter(connection_string=APPINSIGHTS_CONNECTION_STRING),
    sampler=ProbabilitySampler(rate=0.1)  # 10% sampling
)

# Métriques custom
from opencensus.stats import aggregation as aggregation_module
from opencensus.stats import measure as measure_module
from opencensus.stats import stats as stats_module
from opencensus.stats import view as view_module
from opencensus.tags import tag_map as tag_map_module

# Mesures
m_request_latency = measure_module.MeasureFloat("llm/request_latency", "Latency of LLM requests", "ms")
m_tokens_processed = measure_module.MeasureInt("llm/tokens_processed", "Number of tokens processed", "tokens")

# Vues
latency_view = view_module.View(
    "llm/request_latency_distribution",
    "Distribution of LLM request latencies",
    [],
    m_request_latency,
    aggregation_module.DistributionAggregation([50, 100, 200, 500, 1000, 2000, 5000])
)

stats = stats_module.stats
view_manager = stats.view_manager
view_manager.register_view(latency_view)
mmap = stats.stats_recorder

# Exemple d'utilisation
def handle_request(request):
    with tracer.span(name="handle_llm_request"):
        start_time = time.time()
        
        try:
            response = forward_to_litellm(request)
            
            # Enregistrer métriques
            latency_ms = (time.time() - start_time) * 1000
            mmap.measure_float_put(m_request_latency, latency_ms)
            mmap.measure_int_put(m_tokens_processed, response.get('usage', {}).get('total_tokens', 0))
            
            logger.info(f"Request successful - Latency: {latency_ms:.2f}ms")
            return response
            
        except Exception as e:
            logger.exception("Request failed", extra={"error": str(e)})
            raise
```

### 3. Variables d'Environnement

```bash
# .env
APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=...;IngestionEndpoint=https://canadacentral-1.in.applicationinsights.azure.com/"
```

---

## 📊 Métriques Clés

| Métrique | Type | Description | Seuil Alerte |
|----------|------|-------------|--------------|
| **request_latency** | Distribution | Latence P50/P95/P99 | P95 > 2000ms |
| **tokens_processed** | Counter | Total tokens traités | - |
| **error_rate** | Percentage | Taux d'erreur HTTP 5xx | >5% |
| **availability** | Percentage | Uptime endpoint | <99% |

---

## 📈 Dashboard Azure Portal

### Requêtes KQL

**P95 Latency** :
```kql
customMetrics
| where name == "llm/request_latency"
| summarize percentile(value, 95) by bin(timestamp, 5m)
| render timechart
```

**Throughput** :
```kql
customMetrics
| where name == "llm/request_count"
| summarize sum(value) by bin(timestamp, 1h)
| render barchart
```

**Error Rate** :
```kql
traces
| where severityLevel >= 3  // Error or Critical
| summarize count() by bin(timestamp, 5m)
| render timechart
```

---

## 🧪 Tests

### Tests d'Intégration

- [ ] Métriques envoyées à Application Insights
- [ ] Traces visibles dans Azure Portal
- [ ] Dashboard affiche données en temps réel
- [ ] Alerts déclenchés correctement
- [ ] Coûts conformes (sampling 10%)

---

## 📋 Checklist Implémentation

- [ ] Provisionner Application Insights (Bicep)
- [ ] Installer SDK Python (`pip install opencensus-ext-azure`)
- [ ] Configurer logging handler
- [ ] Configurer tracing exporter
- [ ] Implémenter métriques custom
- [ ] Tester envoi métriques (local)
- [ ] Créer dashboard Azure Portal
- [ ] Configurer alerts
- [ ] Documenter métriques dans README

---

_Dernière mise à jour : 2026-06-05_
