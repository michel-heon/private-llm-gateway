# RECIT-104 : Adapter configuration LiteLLM pour dual runtime

**Type** : Récit Utilisateur  
**ID** : RECIT-104  
**Épopée** : [EPOP-001](../Épopées/EPOP-001-support-macmlx.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** pouvoir switcher facilement entre Ollama et macMLX  
**Afin de** comparer les performances ou utiliser selon le contexte

---

## ✅ Critères d'Acceptation

- [ ] Variable d'environnement `LLM_RUNTIME=ollama|macmlx`
- [ ] LiteLLM route vers le bon port (11434 ou 8080)
- [ ] Configuration yaml adaptative (`config/litellm.yaml`)
- [ ] Documentation du switch dans README

---

## 📊 Informations

**Priorité** : Could Have  
**Effort** : 5 points  
**Sprint** : Sprint 2  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [ADR-600](../../adr/600-DEVOPS-bootstrap-configuration-management.md) : Configuration management
- ✅ [RECIT-101](RECIT-101-documenter-macmlx.md) : Documentation (complété)
- ✅ [RECIT-102](RECIT-102-script-demarrage-macmlx.md) : Script macMLX (requis)
- ✅ [RECIT-201](RECIT-201-bootstrap-config.md) : Bootstrap config (requis)

---

## 📝 Spécifications Techniques

### Variable d'Environnement

Fichier `.env` :
```bash
# LLM Runtime selection
LLM_RUNTIME=macmlx  # Options: ollama | macmlx
```

### Configuration LiteLLM Adaptative

Fichier `config/litellm.yaml` :
```yaml
model_list:
  - model_name: gpt-4
    litellm_params:
      model: ollama/qwen2.5-coder:32b
      # Port dynamique selon LLM_RUNTIME
      api_base: ${LLM_API_BASE}  # http://127.0.0.1:11434 ou :8080
```

### Script de Configuration

```bash
# scripts/config-select-runtime.sh
#!/usr/bin/env bash

case "$LLM_RUNTIME" in
  ollama)
    export LLM_API_BASE="http://127.0.0.1:11434"
    export LLM_PORT=11434
    ;;
  macmlx)
    export LLM_API_BASE="http://127.0.0.1:8080"
    export LLM_PORT=8080
    ;;
  *)
    echo "❌ LLM_RUNTIME invalide: $LLM_RUNTIME"
    exit 1
    ;;
esac
```

### Cible Makefile

```makefile
## runtime-switch: Switcher entre Ollama et macMLX
runtime-switch:
	@./scripts/config-select-runtime.sh
	@printf "✅ Runtime configuré: $(LLM_RUNTIME)\n"
```

---

## 🧪 Tests

### Tests Fonctionnels

- [ ] `LLM_RUNTIME=ollama` → LiteLLM utilise port 11434
- [ ] `LLM_RUNTIME=macmlx` → LiteLLM utilise port 8080
- [ ] Erreur si runtime invalide
- [ ] Switch sans redémarrage LiteLLM (si possible)

### Tests d'Intégration

- [ ] VS Code Copilot fonctionne avec Ollama
- [ ] VS Code Copilot fonctionne avec macMLX
- [ ] Benchmark comparatif documenté

---

## 📋 Checklist Implémentation

- [ ] Ajouter `LLM_RUNTIME` dans `.env.example`
- [ ] Créer script `config-select-runtime.sh`
- [ ] Adapter `config/litellm.yaml` pour variable
- [ ] Mettre à jour `scripts/litellm-start.sh`
- [ ] Ajouter cible Makefile `runtime-switch`
- [ ] Documenter switch dans README
- [ ] Tester Ollama ↔ macMLX
- [ ] Créer guide comparaison performance

---

_Dernière mise à jour : 2026-06-05_
