# 📚 Architecture Decision Records (ADR) — Private LLM Gateway

**Index central** de toutes les décisions architecturales du projet **Private LLM Gateway**.

> Le projet est un gateway HTTPS sécurisé pour exposer des LLMs locaux (Ollama) via une API compatible OpenAI. Utilise LiteLLM comme gateway, Azure Relay Hybrid Connection pour la connectivité privée, et un proxy HTTPS Azure comme point d'entrée public. Conçu pour VS Code BYOK / Copilot Chat avec endpoints personnalisés.

---

## 🗂️ Documents du Système ADR

| Document | Description |
|----------|-------------|
| **[ADR-000](./000-META-processus-creation-adr.md)** | Processus et règles de création des ADRs |
| **[TAXONOMY.md](./TAXONOMY.md)** | Classification détaillée (7 dimensions) |
| **[adr-template-ai-optimized.md](./adr-template-ai-optimized.md)** | Template à copier pour un nouvel ADR |
| **[README.md](./README.md)** | Ce fichier (index et guide rapide) |

---

## ⚡ Créer un Nouvel ADR Rapidement

```bash
# 1. Identifier la plage de catégorie (voir tableau Numérotation)
# 2. Trouver le prochain numéro disponible dans la plage
ls -1 docs/adr/6*.md | tail -1   # Exemple: bloc DEVOPS (600-699)

# 3. Créer le fichier depuis le template
cp docs/adr/adr-template-ai-optimized.md docs/adr/606-DEVOPS-nouvelle-decision.md

# 4. Rédiger, committer et mettre à jour ce README
git add docs/adr/606-DEVOPS-nouvelle-decision.md docs/adr/README.md
git commit -m "docs(adr): ADR-606 [DEVOPS] Nouvelle décision"
```

> **Convention de commit** : `docs(adr): ADR-NNN [CATÉGORIE] Titre court`

---

## 📋 Index des ADRs par Catégorie

### 🔧 META — Méta-processus (000-099)

| ADR | Titre | Statut | Date | Domaine |
|-----|-------|--------|------|------|
| [000](./000-META-processus-creation-adr.md) | Processus de Création et Gestion des ADR | ✅ Accepté | 2026-06-04 | Gouvernance |

---

### 🏗️ ARCH — Architecture (100-199)

| ADR | Titre | Statut | Date | Domaine |
|-----|-------|--------|------|------|
| *(aucun ADR pour l'instant)* | | | | |

---

### 🖥️ INFRA — Infrastructure Azure & Déploiement (200-299)

| ADR | Titre | Statut | Date | Domaine |
|-----|-------|--------|------|---------|
| *(aucun ADR pour l'instant)* | | | | |

---

### 🔒 SEC — Sécurité & Confidentialité (300-399)

| ADR | Titre | Statut | Date | Domaine |
|-----|-------|--------|------|------|
| *(aucun ADR pour l'instant)* | | | | |

---

### 🗄️ DATA — Données, Embeddings & Vecteurs (400-499)

| ADR | Titre | Statut | Date | Domaine |
|-----|-------|--------|------|------|
| *(aucun ADR pour l'instant)* | | | | |

---

### 🔌 API — Interfaces REST & OpenAI Compatibility (500-599)

| ADR | Titre | Statut | Date | Domaine |
|-----|-------|--------|------|------|
| *(aucun ADR pour l'instant)* | | | | |

---

### ⚙️ DEVOPS — CI/CD, automation, scripts (600-699)

| ADR | Titre | Statut | Date | Domaine |
|-----|-------|--------|------|------|
| [600](./600-DEVOPS-bootstrap-configuration-management.md) | Gestion Multi-Format des Variables de Configuration | ✅ Accepté | 2026-06-05 | DevOps |
| [601](./601-DEVOPS-nomenclature-scripts.md) | Nomenclature des Scripts et Règles Makefile | ✅ Accepté | 2026-06-05 | DevOps |
| [602](./602-DEVOPS-makefile-orchestrateur.md) | Makefile comme Orchestrateur de Scripts | ✅ Accepté | 2026-06-05 | DevOps |
| [605](./605-DEVOPS-gestion-couleurs-scripts-make.md) | Gestion des couleurs dans les scripts Make | ✅ Accepté | 2026-06-05 | DevOps |
| [607](./607-DEVOPS-gestion-options-scripts-bash.md) | Gestion des Options dans les Scripts Bash | ✅ Accepté | 2026-06-05 | DevOps |

---

### 🧪 TEST — Tests, validation, monitoring (700-799)

| ADR | Titre | Statut | Date | Domaine |
|-----|-------|--------|------|------|
| *(aucun ADR pour l'instant)* | | | | |

---

### 💼 BIZ — Licensing open-source, distribution (800-899)

| ADR | Titre | Statut | Date | Domaine |
|-----|-------|--------|------|------|
| *(aucun ADR pour l'instant)* | | | | |

---

## 📊 Statistiques

| Indicateur | Valeur |
|-----------|--------|
| **Total ADRs** | 6 |
| **Acceptés** | 6 |
| **Supersédés** | 0 |
| **Proposés** | 0 |
| **Brouillons** | 0 |
| **Par Domaine** | META: 1, DEVOPS: 5 |

---

## 🔍 Numérotation par Catégorie

| Préfixe | Plage | Domaine | Prochains disponibles |
|---------|-------|---------|----------------------|
| `META` | 000-099 | Méta-processus | 001 |
| `ARCH` | 100-199 | Architecture gateway & flux de données | 100 |
| `INFRA` | 200-299 | Infrastructure Azure, déploiement, networking | 200 |
| `SEC` | 300-399 | Sécurité, authentification, TLS | 300 |
| `DATA` | 400-499 | Modèles, configuration, persistance | 400 |
| `API` | 500-599 | Interfaces REST, OpenAI compatibility, LiteLLM | 500 |
| `DEVOPS` | 600-699 | CI/CD, automation, scripts | 603, 604, 606, 608+ |
| `TEST` | 700-799 | Tests, validation, monitoring | 700 |
| `BIZ` | 800-899 | Licensing, distribution | 800 |

---

## 🏷️ Statuts

| Emoji | Statut | Description |
|-------|--------|-------------|
| 🔄 | Brouillon / Proposé | En cours de rédaction ou en attente de validation |
| ✅ | Accepté | Décision approuvée et implémentée |
| ❌ | Rejeté | Proposition refusée (archivée pour référence) |
| ⚠️ | Déprécié | Obsolète, non remplacé |
| ➡️ | Supersédé | Remplacé par un ADR plus récent |

---

## 🔗 Ressources Projet

- [Private LLM Gateway GitHub](https://github.com/michel-heon/private-llm-gateway)
- [Ollama](https://ollama.com/)
- [LiteLLM](https://docs.litellm.ai/)
- [Azure Relay](https://learn.microsoft.com/azure/azure-relay/)
- [Caddy Server](https://caddyserver.com/)
- [Nginx](https://nginx.org/)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference)
- [ADR Best Practices](https://adr.github.io/)

---

_Mise à jour : 2026-06-05_
