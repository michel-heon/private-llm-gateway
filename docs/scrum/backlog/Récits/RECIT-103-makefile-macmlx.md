# RECIT-103 : Ajouter cible Makefile pour macMLX

**Type** : Récit Utilisateur  
**ID** : RECIT-103  
**Épopée** : [EPOP-001](../Épopées/EPOP-001-support-macmlx.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** une commande `make macmlx-start`  
**Afin de** unifier le lancement avec les autres services

---

## ✅ Critères d'Acceptation

- [ ] Cible `macmlx-start` dans Makefile
- [ ] Cible `macmlx-stop` pour arrêter proprement
- [ ] Cible `macmlx-status` pour vérifier l'état
- [ ] Respecte [ADR-602](../../adr/602-DEVOPS-makefile-orchestrateur.md) (règle des 3 lignes)

---

## 📊 Informations

**Priorité** : Should Have  
**Effort** : 2 points  
**Sprint** : Sprint 1  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [ADR-602](../../adr/602-DEVOPS-makefile-orchestrateur.md) : Makefile orchestrateur
- 📄 [ADR-605](../../adr/605-DEVOPS-gestion-couleurs-scripts-make.md) : Couleurs ANSI
- ✅ [RECIT-102](RECIT-102-script-demarrage-macmlx.md) : Script macmlx-start.sh (requis)

---

## 📝 Spécifications Techniques

### Cibles Makefile

```makefile
# Makefile
.PHONY: macmlx-start macmlx-stop macmlx-status

## macmlx-start: Démarrer le serveur macMLX
macmlx-start:
	@printf "$(GREEN)🚀 Démarrage macMLX...$(RESET)\n"
	@./scripts/macmlx-start.sh

## macmlx-stop: Arrêter le serveur macMLX
macmlx-stop:
	@printf "$(YELLOW)🛑 Arrêt macMLX...$(RESET)\n"
	@pkill -f "macmlx serve" || true

## macmlx-status: Vérifier l'état de macMLX
macmlx-status:
	@./scripts/endpoint-check-local.sh --port 8080 --service macmlx
```

### Règle des 3 Lignes (ADR-602)

Chaque cible Makefile doit :
1. Logger l'action (avec couleur)
2. Déléguer la logique au script
3. Gérer le code retour

**✅ Conforme** :
```makefile
macmlx-start:
	@printf "$(GREEN)🚀 Démarrage macMLX...$(RESET)\n"
	@./scripts/macmlx-start.sh
```

**❌ Non conforme** (logique dans Make) :
```makefile
macmlx-start:
	@if ! command -v macmlx &> /dev/null; then \
		echo "❌ macMLX non installé"; \
		exit 1; \
	fi
	@macmlx serve --host 0.0.0.0 --port 8080
```

---

## 🧪 Tests

### Tests Manuels

- [ ] `make macmlx-start` démarre macMLX
- [ ] `make macmlx-stop` arrête macMLX
- [ ] `make macmlx-status` affiche état (running/stopped)
- [ ] Logs colorés visibles
- [ ] Erreurs remontées correctement

### Intégration

- [ ] Compatible avec `make start` (global)
- [ ] Compatible avec `make stop` (global)
- [ ] Ne casse pas targets existants (ollama, litellm)

---

## 📋 Checklist Implémentation

- [ ] Ajouter cibles dans Makefile
- [ ] Implémenter `macmlx-start`
- [ ] Implémenter `macmlx-stop`
- [ ] Implémenter `macmlx-status`
- [ ] Ajouter help text (`make help`)
- [ ] Tester compatibilité macOS/Linux
- [ ] Documenter dans README

---

_Dernière mise à jour : 2026-06-05_
