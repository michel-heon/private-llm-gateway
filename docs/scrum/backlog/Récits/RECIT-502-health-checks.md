# RECIT-502 : Ajouter health checks endpoints

**Type** : Récit Utilisateur  
**ID** : RECIT-502  
**Épopée** : [EPOP-005](../Épopées/EPOP-005-observabilite-monitoring.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** des endpoints `/health` et `/ready`  
**Afin de** vérifier l'état des services

---

## ✅ Critères d'Acceptation

- [ ] Endpoint `/health` (liveness probe)
- [ ] Endpoint `/ready` (readiness probe)
- [ ] Vérifications : Ollama/macMLX, LiteLLM, Relay
- [ ] Réponse JSON avec détails par composant

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 5 points  
**Sprint** : Sprint 2  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [RECIT-504](RECIT-504-logs-json.md) : Logs JSON (optionnel)
- 🌐 Aucune dépendance bloquante (peut être fait dès Sprint 2)

---

## 📝 Spécifications Techniques

### 1. Endpoint `/health` (Liveness)

**Objectif** : Vérifier que l'application est vivante

```python
from flask import Flask, jsonify
import time

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        "status": "healthy",
        "timestamp": time.time(),
        "service": "llm-gateway-relay-agent"
    }), 200
```

**Réponse** :
```json
{
  "status": "healthy",
  "timestamp": 1704100800,
  "service": "llm-gateway-relay-agent"
}
```

### 2. Endpoint `/ready` (Readiness)

**Objectif** : Vérifier que tous les services dépendants sont prêts

```python
import requests
from typing import Dict

def check_ollama() -> Dict[str, bool]:
    try:
        resp = requests.get("http://127.0.0.1:11434/api/tags", timeout=2)
        return {"ollama": resp.status_code == 200}
    except Exception:
        return {"ollama": False}

def check_litellm() -> Dict[str, bool]:
    try:
        resp = requests.get("http://127.0.0.1:4000/health", timeout=2)
        return {"litellm": resp.status_code == 200}
    except Exception:
        return {"litellm": False}

def check_relay() -> Dict[str, bool]:
    # Vérifier que la connection Relay est active
    # (logique à implémenter selon SDK Azure Relay)
    return {"relay": True}  # Placeholder

@app.route('/ready', methods=['GET'])
def readiness_check():
    checks = {}
    checks.update(check_ollama())
    checks.update(check_litellm())
    checks.update(check_relay())
    
    all_ready = all(checks.values())
    status_code = 200 if all_ready else 503
    
    return jsonify({
        "status": "ready" if all_ready else "not_ready",
        "checks": checks,
        "timestamp": time.time()
    }), status_code
```

**Réponse (succès)** :
```json
{
  "status": "ready",
  "checks": {
    "ollama": true,
    "litellm": true,
    "relay": true
  },
  "timestamp": 1704100800
}
```

**Réponse (échec)** :
```json
{
  "status": "not_ready",
  "checks": {
    "ollama": false,
    "litellm": true,
    "relay": true
  },
  "timestamp": 1704100800
}
```

### 3. Script de Vérification

```bash
#!/usr/bin/env bash
# scripts/endpoint-check-local.sh

ENDPOINT="${1:-http://127.0.0.1:8000}"

echo "Checking $ENDPOINT/health..."
if curl -f -s "$ENDPOINT/health" > /dev/null; then
    echo "✅ Health check passed"
else
    echo "❌ Health check failed"
    exit 1
fi

echo "Checking $ENDPOINT/ready..."
if curl -f -s "$ENDPOINT/ready" > /dev/null; then
    echo "✅ Readiness check passed"
else
    echo "⚠️  Readiness check failed (some services not ready)"
    exit 1
fi
```

---

## 🧪 Tests

### Tests Unitaires

- [ ] `/health` retourne 200 toujours
- [ ] `/ready` retourne 200 si tous services OK
- [ ] `/ready` retourne 503 si un service KO
- [ ] Timeouts gérés (2 secondes max)

### Tests d'Intégration

- [ ] Ollama arrêté → `/ready` retourne 503
- [ ] LiteLLM arrêté → `/ready` retourne 503
- [ ] Tous services démarrés → `/ready` retourne 200

---

## 📋 Checklist Implémentation

### relay_agent.py

- [ ] Ajouter routes Flask `/health` et `/ready`
- [ ] Implémenter `check_ollama()`
- [ ] Implémenter `check_litellm()`
- [ ] Implémenter `check_relay()`
- [ ] Ajouter timeouts (2 secondes)
- [ ] Gérer exceptions proprement

### Scripts

- [ ] Créer `scripts/endpoint-check-local.sh`
- [ ] Ajouter option `--service` (filtrer un service)
- [ ] Ajouter option `--verbose` (afficher détails)

### Documentation

- [ ] Documenter endpoints dans README
- [ ] Ajouter exemples curl
- [ ] Expliquer codes HTTP (200, 503)

---

## 💡 Utilisation Kubernetes (Future)

```yaml
# Liveness Probe
livenessProbe:
  httpGet:
    path: /health
    port: 8000
  initialDelaySeconds: 10
  periodSeconds: 30

# Readiness Probe
readinessProbe:
  httpGet:
    path: /ready
    port: 8000
  initialDelaySeconds: 5
  periodSeconds: 10
```

---

_Dernière mise à jour : 2026-06-05_
