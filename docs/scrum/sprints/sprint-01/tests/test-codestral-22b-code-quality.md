# Test: Codestral-22B Code Quality Validation

## Objectif

Valider la qualité de génération de code de Codestral-22B (22B paramètres, 4-bit quantization) sur Apple Silicon (M2 Max, 64GB RAM) pour des tâches de développement réelles.

## Contexte

- **Modèle:** `mlx-community/Codestral-22B-v0.1-4bit`
- **Plateforme:** macOS ARM64 (M2 Max)
- **RAM Disponible:** 64 GB
- **Endpoint:** `http://127.0.0.1:8080/v1/chat/completions`
- **Température:** 0.1 (réduit les hallucinations)

## Prérequis

```bash
# Vérifier que le modèle est téléchargé
make macmlx-download-status

# Démarrer le serveur Codestral-22B
./scripts/macmlx-start.sh --model mlx-community/Codestral-22B-v0.1-4bit --port 8080

# Vérifier le statut
make macmlx-status
curl http://127.0.0.1:8080/health
```

---

## Test 1: Validation d'email avec regex (Python)

### Commande

```bash
curl -s http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Codestral-22B-v0.1-4bit",
    "messages": [
      {
        "role": "system",
        "content": "You are an expert programmer. Be precise and concise. Always include type hints and docstrings."
      },
      {
        "role": "user",
        "content": "Write a Python function to validate email addresses with regex. Include type hints, docstring, and error handling."
      }
    ],
    "temperature": 0.1,
    "max_tokens": 500
  }' | python3 -m json.tool
```

### Critères de réussite

- ✅ Code syntaxiquement correct (pas d'erreurs Python)
- ✅ Utilise `re` module correctement
- ✅ Type hints présents (`str`, `bool`, etc.)
- ✅ Docstring au format PEP 257
- ✅ Gestion des cas limites (None, string vide)
- ✅ Pattern regex valide pour emails
- ❌ Pas d'hallucinations (imports inexistants, fonctions inventées)

### Résultat attendu

```python
import re
from typing import Optional

def validate_email(email: Optional[str]) -> bool:
    """
    Validate an email address using regex.
    
    Args:
        email: Email address to validate
        
    Returns:
        True if valid, False otherwise
    """
    if not email:
        return False
    
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))
```

---

## Test 2: Parser JSON avec gestion d'erreurs (Python)

### Commande

```bash
curl -s http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Codestral-22B-v0.1-4bit",
    "messages": [
      {
        "role": "system",
        "content": "You are an expert programmer. Provide production-ready code with comprehensive error handling."
      },
      {
        "role": "user",
        "content": "Write a Python function that safely parses JSON from a string, with proper error handling for malformed JSON. Return None if parsing fails."
      }
    ],
    "temperature": 0.1,
    "max_tokens": 400
  }' | python3 -m json.tool
```

### Critères de réussite

- ✅ Utilise `json.loads()` correctement
- ✅ Try/except avec `json.JSONDecodeError`
- ✅ Type hints (`str`, `Optional[dict]`)
- ✅ Retourne `None` en cas d'erreur
- ✅ Ne lève pas d'exception non gérée
- ❌ Pas de bibliothèques inventées

---

## Test 3: API REST avec Express.js (TypeScript)

### Commande

```bash
curl -s http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Codestral-22B-v0.1-4bit",
    "messages": [
      {
        "role": "system",
        "content": "You are an expert TypeScript and Node.js developer. Write clean, type-safe code."
      },
      {
        "role": "user",
        "content": "Create a TypeScript Express.js route handler for GET /users/:id that fetches a user from a database. Include error handling for user not found (404) and internal errors (500)."
      }
    ],
    "temperature": 0.1,
    "max_tokens": 600
  }' | python3 -m json.tool
```

### Critères de réussite

- ✅ Code TypeScript valide
- ✅ Utilise Express types (`Request`, `Response`)
- ✅ Gestion 404 (utilisateur non trouvé)
- ✅ Gestion 500 (erreur serveur)
- ✅ Async/await correctement utilisé
- ✅ Types d'interface pour User
- ❌ Pas de code JavaScript au lieu de TypeScript

---

## Test 4: Algorithme de tri optimisé (Python)

### Commande

```bash
curl -s http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Codestral-22B-v0.1-4bit",
    "messages": [
      {
        "role": "system",
        "content": "You are a computer science expert. Explain complexity and provide efficient implementations."
      },
      {
        "role": "user",
        "content": "Implement quicksort in Python with type hints. Include a docstring explaining the time complexity."
      }
    ],
    "temperature": 0.1,
    "max_tokens": 600
  }' | python3 -m json.tool
```

### Critères de réussite

- ✅ Implémentation correcte de quicksort
- ✅ Complexité temporelle mentionnée (O(n log n) moyenne, O(n²) pire cas)
- ✅ Type hints pour listes
- ✅ Gestion cas de base (liste vide, 1 élément)
- ✅ Partition correcte (pivot)
- ❌ Pas d'algorithme différent (merge sort, etc.)

---

## Test 5: Refactoring de code legacy

### Commande

```bash
curl -s http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Codestral-22B-v0.1-4bit",
    "messages": [
      {
        "role": "system",
        "content": "You are a senior software engineer specialized in code refactoring and best practices."
      },
      {
        "role": "user",
        "content": "Refactor this code to use async/await and proper error handling:\n\nfunction getUser(id, callback) {\n  db.query(\"SELECT * FROM users WHERE id = \" + id, function(err, result) {\n    if (err) callback(err);\n    callback(null, result);\n  });\n}"
      }
    ],
    "temperature": 0.1,
    "max_tokens": 500
  }' | python3 -m json.tool
```

### Critères de réussite

- ✅ Converti en async/await
- ✅ Protection SQL injection (prepared statements)
- ✅ Try/catch pour gestion d'erreurs
- ✅ Retourne une Promise
- ✅ Code plus lisible et moderne
- ❌ Pas de régression (perte de fonctionnalité)

---

## Test 6: Tests unitaires avec Jest (TypeScript)

### Commande

```bash
curl -s http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Codestral-22B-v0.1-4bit",
    "messages": [
      {
        "role": "system",
        "content": "You are a TDD expert. Write comprehensive unit tests with edge cases."
      },
      {
        "role": "user",
        "content": "Write Jest unit tests for a function calculateDiscount(price: number, discountPercent: number): number. Test edge cases: negative values, zero, 100% discount, over 100%."
      }
    ],
    "temperature": 0.1,
    "max_tokens": 700
  }' | python3 -m json.tool
```

### Critères de réussite

- ✅ Utilise Jest syntax (`describe`, `it`, `expect`)
- ✅ Tests pour cas valides
- ✅ Tests pour cas limites (0, négatifs, > 100%)
- ✅ Assertions claires
- ✅ Couverture complète des scénarios
- ❌ Pas de framework de test incorrect (Mocha, Jasmine)

---

## Métriques de performance

### Latence

```bash
# Mesurer le temps de réponse
time curl -s http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Codestral-22B-v0.1-4bit",
    "messages": [{"role": "user", "content": "Write a Python function to reverse a string"}],
    "temperature": 0.1,
    "max_tokens": 200
  }' > /dev/null
```

**Cible:** < 10 secondes pour 200 tokens

### Utilisation RAM

```bash
# Surveiller l'utilisation RAM pendant l'inférence
ps aux | grep mlx_lm.server | awk '{print "RAM: " $6/1024/1024 " GB"}'
```

**Cible:** ~14-18 GB RAM (modèle 22B 4-bit)

### Tokens par seconde

```bash
# Extraire du JSON de réponse
# "usage": {"completion_tokens": X, "total_tokens": Y}
# Diviser completion_tokens par temps écoulé
```

**Cible:** > 10 tokens/seconde sur M2 Max

---

## Grille d'évaluation globale

| Critère | Poids | Score | Notes |
|---------|-------|-------|-------|
| **Correction syntaxique** | 25% | /100 | Code compile/exécute sans erreur |
| **Respect des consignes** | 20% | /100 | Type hints, docstrings, structure |
| **Gestion d'erreurs** | 20% | /100 | Try/catch, validation, edge cases |
| **Absence d'hallucinations** | 20% | /100 | Pas d'imports/APIs inventés |
| **Qualité du code** | 15% | /100 | Lisibilité, bonnes pratiques |
| **TOTAL** | 100% | /100 | |

### Seuils de validation

- **90-100%**: Excellent - Production ready
- **75-89%**: Bon - Nécessite revue mineure
- **60-74%**: Acceptable - Revue approfondie requise
- **< 60%**: Insuffisant - Ne pas utiliser en production

---

## Comparaison avec autres modèles

### Baseline: Qwen2.5-7B-Instruct-4bit (défaut)

Exécuter les mêmes tests avec:
```bash
./scripts/macmlx-start.sh --model mlx-community/Qwen2.5-7B-Instruct-4bit
```

### Baseline: DeepSeek-Coder-V2.5-7B-Instruct-4bit

Exécuter les mêmes tests avec:
```bash
./scripts/macmlx-start.sh --model mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit
```

### Tableau comparatif

| Modèle | Correction | Consignes | Erreurs | Hallucinations | Qualité | TOTAL | Latence | RAM |
|--------|-----------|-----------|---------|----------------|---------|-------|---------|-----|
| Codestral-22B | ? | ? | ? | ? | ? | ? | ? | ~14GB |
| DeepSeek-Coder-7B | ? | ? | ? | ? | ? | ? | ? | ~4GB |
| Qwen2.5-7B | ? | ? | ? | ? | ? | ? | ? | ~4GB |

---

## Rapport de test

### Date: ________________

### Testeur: ________________

### Résultats

**Test 1 (Email validation):** ✅ / ❌  
**Score:** ____/100  
**Notes:** _______________________________________________

**Test 2 (JSON parsing):** ✅ / ❌  
**Score:** ____/100  
**Notes:** _______________________________________________

**Test 3 (Express.js route):** ✅ / ❌  
**Score:** ____/100  
**Notes:** _______________________________________________

**Test 4 (Quicksort):** ✅ / ❌  
**Score:** ____/100  
**Notes:** _______________________________________________

**Test 5 (Refactoring):** ✅ / ❌  
**Score:** ____/100  
**Notes:** _______________________________________________

**Test 6 (Jest tests):** ✅ / ❌  
**Score:** ____/100  
**Notes:** _______________________________________________

### Métriques de performance

- **Latence moyenne (200 tokens):** ______ secondes
- **RAM utilisée:** ______ GB
- **Tokens/seconde:** ______

### Score global: ____/100

### Recommandation

- [ ] ✅ **Approuvé pour production** (score ≥ 90%)
- [ ] ⚠️ **Approuvé avec réserves** (score 75-89%)
- [ ] 📝 **Nécessite amélioration** (score 60-74%)
- [ ] ❌ **Non recommandé** (score < 60%)

### Commentaires

________________________________________________________________

________________________________________________________________

________________________________________________________________

---

## Automatisation (optionnel)

### Script de test automatique

Créer un script Python pour exécuter tous les tests:

```python
#!/usr/bin/env python3
"""
Automated test suite for Codestral-22B code quality.
Usage: python3 test_codestral.py --model mlx-community/Codestral-22B-v0.1-4bit
"""

import requests
import json
import time
from typing import Dict, List

ENDPOINT = "http://127.0.0.1:8080/v1/chat/completions"

def run_test(test_name: str, prompt: str, model: str) -> Dict:
    """Execute a single test and return results."""
    start_time = time.time()
    
    response = requests.post(ENDPOINT, json={
        "model": model,
        "messages": [
            {"role": "system", "content": "You are an expert programmer."},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.1,
        "max_tokens": 500
    })
    
    elapsed = time.time() - start_time
    
    result = response.json()
    return {
        "test": test_name,
        "code": result["choices"][0]["message"]["content"],
        "tokens": result["usage"]["completion_tokens"],
        "latency": elapsed,
        "tokens_per_sec": result["usage"]["completion_tokens"] / elapsed
    }

if __name__ == "__main__":
    # TODO: Implémenter la suite complète
    pass
```

---

## Références

- [Codestral Documentation](https://huggingface.co/mistralai/Codestral-22B-v0.1)
- [MLX Community Models](https://huggingface.co/mlx-community)
- [HumanEval Benchmark](https://github.com/openai/human-eval)
- [Guide VS Code BYOK](../../guides/integration/vscode-copilot-byok.md)
