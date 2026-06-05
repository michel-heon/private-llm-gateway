# RECIT-101 : Documenter installation et configuration macMLX

**Type** : Récit Utilisateur  
**ID** : RECIT-101  
**Épopée** : [EPOP-001](../Épopées/EPOP-001-support-macmlx.md)  
**Statut** : ✅ Complété

---

## 📋 Description

**En tant que** développeur sur Mac Apple Silicon  
**Je veux** une documentation claire pour installer macMLX  
**Afin de** remplacer Ollama par une solution 2x plus rapide

---

## ✅ Critères d'Acceptation

- [x] Guide installation macMLX dans `docs/guides/setup/litellm-ollama.md`
- [x] Comparaison Ollama vs macMLX (tableau performance)
- [x] Configuration LiteLLM pour port 8080
- [x] Benchmark M2 Max documenté (80-100 tokens/sec)

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 2 points  
**Sprint** : Sprint 1  
**Assigné** : Alex

---

## 🔗 Liens

- 📄 Documentation : [docs/guides/setup/litellm-ollama.md](../../../guides/setup/litellm-ollama.md)
- 📄 Architecture : [docs/architecture/overview.md](../../../architecture/overview.md)
- 🔗 GitHub : [mac-mlx repository](https://github.com/magicnight/mac-mlx)

---

## 📝 Notes d'Implémentation

### Travaux Réalisés (2026-06-05)

1. **Section macMLX ajoutée** dans `litellm-ollama.md`
   - Installation via Homebrew
   - Configuration serveur (port 8080)
   - Intégration LiteLLM

2. **Tableau comparatif** créé :
   | Critère | Ollama | macMLX |
   |---------|--------|--------|
   | Performance M2 Max | 40-50 tok/s | 80-100 tok/s |
   | Port défaut | 11434 | 8080 |

3. **Architecture overview** mise à jour avec choix runtime

### Benchmarks Documentés

- **Machine** : MacBook Pro M2 Max
- **Modèle testé** : Qwen 2.5 Coder 32B
- **Performance** :
  - Ollama : 40-50 tokens/sec
  - macMLX : 80-100 tokens/sec (2x speedup)

---

## ✅ Validation

**Date de complétion** : 2026-06-05  
**Validé par** : Alex  
**Commit** : `b4b5ed9`

**Tests effectués** :
- [x] Documentation lisible et complète
- [x] Liens internes fonctionnels
- [x] Benchmark vérifié sur M2 Max

---

_Dernière mise à jour : 2026-06-05_
