# RECIT-102 : Créer script de démarrage macMLX

**Type** : Récit Utilisateur  
**ID** : RECIT-102  
**Épopée** : [EPOP-001](../Épopées/EPOP-001-support-macmlx.md)  
**Statut** : 📋 To Do

---

## 📋 Description

**En tant que** développeur  
**Je veux** un script shell pour démarrer macMLX facilement  
**Afin de** éviter de mémoriser les commandes CLI

---

## ✅ Critères d'Acceptation

- [ ] Script `scripts/macmlx-start.sh` créé
- [ ] Supporte options `--model`, `--port`, `--verbose`
- [ ] Gère les erreurs (macMLX non installé, port occupé)
- [ ] Suit la nomenclature [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md) (`{object}-{action}.sh`)

---

## 📊 Informations

**Priorité** : Must Have  
**Effort** : 3 points  
**Sprint** : Sprint 1  
**Assigné** : Alex

---

## 🔗 Dépendances

- 📄 [ADR-601](../../adr/601-DEVOPS-nomenclature-scripts.md) : Nomenclature scripts
- 📄 [ADR-607](../../adr/607-DEVOPS-gestion-options-scripts-bash.md) : Parsing options Bash
- ✅ [RECIT-101](RECIT-101-documenter-macmlx.md) : Documentation macMLX (complété)

---

## 📝 Spécifications Techniques

### Signature du Script

```bash
#!/usr/bin/env bash
# scripts/macmlx-start.sh
# Démarre le serveur macMLX avec options configurables

macmlx-start.sh [OPTIONS]

Options:
  --model MODEL      Modèle à charger (défaut: qwen2.5-coder:32b)
  --port PORT        Port d'écoute (défaut: 8080)
  -v, --verbose      Mode verbeux
  -h, --help         Afficher l'aide
```

### Gestion des Erreurs

1. **macMLX non installé** :
   ```
   ❌ Erreur: macMLX n'est pas installé
   💡 Installer avec: brew install macmlx
   ```

2. **Port occupé** :
   ```
   ❌ Erreur: Port 8080 déjà utilisé
   💡 Utiliser --port 8081 ou arrêter le processus existant
   ```

3. **Modèle introuvable** :
   ```
   ❌ Erreur: Modèle 'qwen2.5-coder:32b' introuvable
   💡 Télécharger avec: macmlx pull qwen2.5-coder:32b
   ```

### Exemple d'Utilisation

```bash
# Démarrage standard
./scripts/macmlx-start.sh

# Avec modèle personnalisé
./scripts/macmlx-start.sh --model llama3.2:3b --port 8081

# Mode verbeux
./scripts/macmlx-start.sh --verbose
```

---

## 🧪 Tests

### Tests Unitaires

- [ ] Script affiche aide avec `--help`
- [ ] Option `--model` change le modèle
- [ ] Option `--port` change le port
- [ ] Erreur si macMLX non installé
- [ ] Erreur si port occupé
- [ ] Mode verbeux affiche logs

### Tests d'Intégration

- [ ] macMLX démarre correctement
- [ ] Endpoint http://localhost:8080 répond
- [ ] CTRL-C arrête proprement le serveur

---

## 📋 Checklist Implémentation

- [ ] Créer fichier `scripts/macmlx-start.sh`
- [ ] Implémenter fonction `_usage()`
- [ ] Implémenter parsing options (while/case/shift)
- [ ] Ajouter vérifications pré-démarrage
- [ ] Implémenter gestion d'erreurs
- [ ] Ajouter logs colorés (ADR-605)
- [ ] Rendre exécutable (`chmod +x`)
- [ ] Tester sur macOS (M1/M2/M3)
- [ ] Mettre à jour documentation

---

_Dernière mise à jour : 2026-06-05_
