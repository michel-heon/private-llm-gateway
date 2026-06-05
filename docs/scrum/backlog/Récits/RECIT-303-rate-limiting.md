# RECIT-303 : Ajouter rate limiting au proxy Azure

**Type** : Récit Utilisateur  
**ID** : RECIT-303  
**Épopée** : [EPOP-003](../Épopées/EPOP-003-securite.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** DevOps engineer  
**Je veux** limiter les requêtes par IP/utilisateur  
**Afin de** éviter les abus et contrôler les coûts

---

## ✅ Critères d'Acceptation

- [ ] Configuration rate limit (ex: 100 req/min/IP)
- [ ] Réponse HTTP 429 avec Retry-After header
- [ ] Métriques de throttling dans Application Insights
- [ ] Documentation des limites dans README

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 5 points  
**Sprint** : Sprint 2  
**Assigné** : Jordan

---

## 🔗 Dépendances

- 🌐 [RECIT-402](RECIT-402-bicep-proxy.md) : HTTPS proxy déployé (bloquant)
- 📄 [RECIT-501](RECIT-501-application-insights.md) : App Insights (pour métriques)

---

## 📝 Spécifications Techniques

### Option A : Azure App Service

**Intégration avec Azure Front Door** (recommandé) :
```bicep
resource frontDoor 'Microsoft.Cdn/profiles@2023-05-01' = {
  name: 'fd-llm-gateway'
  location: 'global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  properties: {
    rateLimitRules: [
      {
        name: 'limitByIP'
        rateLimitThreshold: 100
        rateLimitDurationInMinutes: 1
        action: 'Block'
      }
    ]
  }
}
```

### Option B : Nginx (si proxy Nginx)

**nginx.conf** :
```nginx
http {
    # Limite par IP
    limit_req_zone $binary_remote_addr zone=ip_limit:10m rate=100r/m;
    
    server {
        listen 443 ssl;
        
        location / {
            limit_req zone=ip_limit burst=20 nodelay;
            limit_req_status 429;
            
            # Headers de réponse
            add_header Retry-After 60 always;
            add_header X-RateLimit-Limit 100 always;
            add_header X-RateLimit-Remaining $limit_req_remaining always;
            
            proxy_pass http://localhost:4000;
        }
    }
}
```

### Option C : Caddy (si proxy Caddy)

**Caddyfile** :
```caddyfile
{
    order rate_limit before basicauth
}

llm.example.com {
    rate_limit {
        zone ip {
            key {remote_host}
            events 100
            window 1m
        }
        
        status 429
        response {
            header Retry-After 60
            header X-RateLimit-Limit 100
        }
    }
    
    reverse_proxy localhost:4000
}
```

### Réponse HTTP 429

```http
HTTP/1.1 429 Too Many Requests
Retry-After: 60
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1704100800
Content-Type: application/json

{
  "error": {
    "code": "rate_limit_exceeded",
    "message": "Trop de requêtes. Limite: 100 req/min par IP.",
    "retry_after": 60
  }
}
```

---

## 🧪 Tests

### Tests Fonctionnels

- [ ] 100 requêtes/min passent
- [ ] 101ème requête reçoit HTTP 429
- [ ] Header Retry-After présent
- [ ] Rate limit reset après 1 minute
- [ ] Plusieurs IPs ne s'affectent pas

### Tests de Performance

- [ ] Overhead rate limiting <10ms
- [ ] Métriques throttling dans App Insights
- [ ] Dashboard monitoring disponible

---

## 📋 Checklist Implémentation

### Préparation
- [ ] Choisir proxy (Front Door / Nginx / Caddy)
- [ ] Définir limites (100 req/min recommandé)
- [ ] Décider scope (par IP / par user / global)

### Implémentation
- [ ] Configurer rate limiting (option choisie)
- [ ] Tester limites en local
- [ ] Déployer sur Azure
- [ ] Configurer métriques App Insights
- [ ] Créer alerts (si >90% requêtes throttled)

### Documentation
- [ ] Documenter limites dans README
- [ ] Ajouter section troubleshooting (429)
- [ ] Mettre à jour docs/reference/security.md

---

## 📚 Limites Recommandées

| Scope | Limite | Burst | Justification |
|-------|--------|-------|---------------|
| **Par IP** | 100 req/min | 20 req | Usage individuel raisonnable |
| **Global** | 1000 req/min | 100 req | Capacité backend |
| **Par user** | 50 req/min | 10 req | Si auth implementé |

---

_Dernière mise à jour : 2026-06-05_
