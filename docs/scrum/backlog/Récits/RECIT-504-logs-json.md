# RECIT-504 : Implémenter logs structurés JSON

**Type** : Récit Utilisateur  
**ID** : RECIT-504  
**Épopée** : [EPOP-005](../Épopées/EPOP-005-observabilite-monitoring.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** DevOps engineer  
**Je veux** que tous les logs soient en JSON  
**Afin de** faciliter le parsing et les requêtes KQL

---

## ✅ Critères d'Acceptation

- [ ] Formatter JSON pour logging Python
- [ ] Champs standard : timestamp, level, service, message, context
- [ ] Compatible Application Insights
- [ ] Migration logs existants

---

## 📊 Informations

**Priorité** : Should Have  
**Effort** : 5 points  
**Sprint** : Sprint 3  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [RECIT-302](RECIT-302-log-redaction.md) : Log redaction (synergique)
- 📄 [RECIT-501](RECIT-501-application-insights.md) : App Insights (consommateur)

---

## 📝 Implémentation

### 1. JSON Formatter (Python)

```python
import logging
import json
import time
from typing import Any, Dict

class JSONFormatter(logging.Formatter):
    """
    Formatter JSON pour logs structurés
    """
    def __init__(self, service_name: str = "llm-gateway"):
        super().__init__()
        self.service_name = service_name
    
    def format(self, record: logging.LogRecord) -> str:
        log_data: Dict[str, Any] = {
            "timestamp": time.time(),
            "level": record.levelname,
            "service": self.service_name,
            "logger": record.name,
            "message": record.getMessage(),
            "module": record.module,
            "function": record.funcName,
            "line": record.lineno
        }
        
        # Contexte additionnel
        if hasattr(record, 'extra'):
            log_data['context'] = record.extra
        
        # Exception traceback
        if record.exc_info:
            log_data['exception'] = self.formatException(record.exc_info)
        
        return json.dumps(log_data, ensure_ascii=False)

# Configuration
logging.basicConfig(
    level=logging.INFO,
    handlers=[
        logging.StreamHandler()
    ]
)

# Appliquer formatter
for handler in logging.root.handlers:
    handler.setFormatter(JSONFormatter(service_name="relay-agent"))
```

### 2. Utilisation dans relay_agent.py

```python
import logging

logger = logging.getLogger(__name__)

# Exemple avec contexte
logger.info(
    "Request forwarded to LiteLLM",
    extra={
        "request_id": "req-123",
        "model": "qwen2.5-coder:32b",
        "latency_ms": 1234.5,
        "tokens": 256
    }
)

# Exemple avec erreur
try:
    response = forward_request()
except Exception as e:
    logger.exception(
        "Failed to forward request",
        extra={
            "request_id": "req-123",
            "error_type": type(e).__name__
        }
    )
```

### 3. Exemple de Log JSON

```json
{
  "timestamp": 1704100800.123,
  "level": "INFO",
  "service": "relay-agent",
  "logger": "relay_agent.main",
  "message": "Request forwarded to LiteLLM",
  "module": "main",
  "function": "handle_request",
  "line": 42,
  "context": {
    "request_id": "req-123",
    "model": "qwen2.5-coder:32b",
    "latency_ms": 1234.5,
    "tokens": 256
  }
}
```

### 4. Requêtes KQL (Application Insights)

**Filtrer par niveau** :
```kql
traces
| where customDimensions.level == "ERROR"
| project timestamp, message, customDimensions
```

**Latence moyenne par modèle** :
```kql
traces
| where message == "Request forwarded to LiteLLM"
| extend latency = todouble(customDimensions.context.latency_ms)
| extend model = tostring(customDimensions.context.model)
| summarize avg(latency) by model
```

**Top erreurs** :
```kql
traces
| where customDimensions.level == "ERROR"
| extend error_type = tostring(customDimensions.context.error_type)
| summarize count() by error_type
| order by count_ desc
```

---

## 🧪 Tests

### Tests Unitaires

- [ ] JSONFormatter génère JSON valide
- [ ] Champs obligatoires présents
- [ ] Contexte additionnel préservé
- [ ] Exceptions formattées correctement
- [ ] Unicode supporté (émojis, caractères spéciaux)

### Tests d'Intégration

- [ ] Logs visibles dans Application Insights
- [ ] Requêtes KQL fonctionnelles
- [ ] Aucun log perdu
- [ ] Performance acceptable (<1ms overhead)

---

## 📋 Checklist Implémentation

### Python

- [ ] Créer classe `JSONFormatter`
- [ ] Configurer logging root
- [ ] Migrer logs relay_agent.py
- [ ] Ajouter contexte pertinent (request_id, model, latency)
- [ ] Tests unitaires formatter

### Intégration

- [ ] Tester avec Application Insights
- [ ] Créer exemples de requêtes KQL
- [ ] Documenter champs JSON standards
- [ ] Créer guide troubleshooting logs

### Documentation

- [ ] Documenter format JSON
- [ ] Ajouter exemples de logs
- [ ] Créer guide requêtes KQL
- [ ] Mettre à jour README

---

## 📚 Standards de Logging

### Champs Obligatoires

| Champ | Type | Description | Exemple |
|-------|------|-------------|---------|
| `timestamp` | float | Unix timestamp (secondes) | 1704100800.123 |
| `level` | string | Niveau de log | "INFO", "ERROR" |
| `service` | string | Nom du service | "relay-agent" |
| `message` | string | Message principal | "Request forwarded" |

### Champs Optionnels (context)

| Champ | Type | Description |
|-------|------|-------------|
| `request_id` | string | ID unique de requête |
| `model` | string | Nom du modèle LLM |
| `latency_ms` | float | Latence en millisecondes |
| `tokens` | int | Nombre de tokens |
| `error_type` | string | Type d'exception |

---

_Dernière mise à jour : 2026-06-05_
