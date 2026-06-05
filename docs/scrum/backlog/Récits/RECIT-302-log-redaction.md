# RECIT-302 : Implémenter log redaction

**Type** : Récit Utilisateur  
**ID** : RECIT-302  
**Épopée** : [EPOP-003](../Épopées/EPOP-003-securite.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** security engineer  
**Je veux** que les prompts et API keys soient masqués dans les logs  
**Afin de** éviter les fuites de données sensibles

---

## ✅ Critères d'Acceptation

- [ ] Fonction Python `redact_sensitive_data()` dans relay_agent.py
- [ ] Patterns regex pour API keys, connection strings
- [ ] Logs structurés (JSON) avec champ `redacted: true`
- [ ] Tests unitaires de redaction

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 5 points  
**Sprint** : Sprint 2  
**Assigné** : Riley / Alex

---

## 🔗 Dépendances

- 📄 [RECIT-504](RECIT-504-logs-json.md) : Logs JSON (peut être parallèle)
- 📄 [docs/reference/security.md](../../../reference/security.md) : Security baseline

---

## 📝 Spécifications Techniques

### Fonction de Redaction

```python
import re
import logging

# Patterns à masquer
SENSITIVE_PATTERNS = {
    'api_key': r'(api[_-]?key["\s:=]+)([a-zA-Z0-9-_]{20,})',
    'connection_string': r'(Endpoint=sb://[^;]+;SharedAccessKeyName=[^;]+;SharedAccessKey=)([^;]+)',
    'bearer_token': r'(Bearer\s+)([a-zA-Z0-9_\-\.]+)',
    'prompt_content': r'("prompt"\s*:\s*")([^"]{50,})(")',  # Tronquer prompts longs
}

def redact_sensitive_data(message: str) -> tuple[str, bool]:
    """
    Masque les données sensibles dans un message.
    
    Returns:
        (message_masqué, was_redacted)
    """
    redacted = False
    output = message
    
    for pattern_name, pattern in SENSITIVE_PATTERNS.items():
        if re.search(pattern, output):
            redacted = True
            output = re.sub(pattern, r'\1***REDACTED***\3', output)
    
    return output, redacted

# Wrapper logging
class RedactingFormatter(logging.Formatter):
    def format(self, record):
        original_msg = super().format(record)
        redacted_msg, was_redacted = redact_sensitive_data(original_msg)
        
        if was_redacted:
            # Ajouter marqueur dans log JSON
            record.__dict__['redacted'] = True
        
        record.msg = redacted_msg
        return redacted_msg
```

### Configuration Logging

```python
import logging.config

LOGGING_CONFIG = {
    'version': 1,
    'formatters': {
        'redacting': {
            '()': RedactingFormatter,
            'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        }
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'redacting'
        }
    },
    'root': {
        'level': 'INFO',
        'handlers': ['console']
    }
}

logging.config.dictConfig(LOGGING_CONFIG)
```

### Tests de Redaction

```python
def test_redact_api_key():
    message = 'Using api_key=sk-1234567890abcdefghij'
    redacted, was_redacted = redact_sensitive_data(message)
    
    assert '***REDACTED***' in redacted
    assert 'sk-1234567890abcdefghij' not in redacted
    assert was_redacted is True

def test_redact_connection_string():
    message = 'Connection: Endpoint=sb://test.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=SECRET123'
    redacted, was_redacted = redact_sensitive_data(message)
    
    assert 'SECRET123' not in redacted
    assert was_redacted is True

def test_no_redaction_needed():
    message = 'Normal log message without secrets'
    redacted, was_redacted = redact_sensitive_data(message)
    
    assert redacted == message
    assert was_redacted is False
```

---

## 🧪 Tests

### Tests Unitaires

- [ ] API keys masquées
- [ ] Connection strings masquées
- [ ] Bearer tokens masqués
- [ ] Prompts longs tronqués (>50 chars)
- [ ] Messages normaux non modifiés
- [ ] Flag `redacted: true` ajouté

### Tests d'Intégration

- [ ] Logs relay agent masqués
- [ ] Exceptions ne contiennent pas secrets
- [ ] Stack traces sécurisées
- [ ] Application Insights reçoit logs masqués

---

## 📋 Checklist Implémentation

- [ ] Créer fonction `redact_sensitive_data()`
- [ ] Définir patterns regex sensibles
- [ ] Créer classe `RedactingFormatter`
- [ ] Configurer logging avec formatter
- [ ] Écrire tests unitaires
- [ ] Intégrer dans `relay_agent.py`
- [ ] Tester avec données réelles (environnement test)
- [ ] Vérifier logs Application Insights
- [ ] Documenter patterns dans security.md

---

_Dernière mise à jour : 2026-06-05_
