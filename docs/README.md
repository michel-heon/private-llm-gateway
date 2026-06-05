# Documentation — Private LLM Gateway

Documentation complète pour le projet **Private LLM Gateway**, un gateway HTTPS sécurisé exposant des LLMs locaux (Ollama, macMLX) via une API compatible OpenAI.

## 📂 Structure de la Documentation

Cette documentation suit le **[Divio Documentation System](https://documentation.divio.com/)** pour une navigation intuitive :

```
docs/
├── README.md                     # Ce fichier (point d'entrée)
├── adr/                          # Architecture Decision Records
├── architecture/                 # Vue d'ensemble système
├── guides/                       # Guides pratiques
│   ├── setup/                    # Installation et configuration
│   └── integration/              # Intégration avec clients
└── reference/                    # Documentation de référence
```

---

## 🏗️ Architecture

Comprendre la conception globale du système.

| Document | Description |
|----------|-------------|
| [**overview.md**](architecture/overview.md) | Vue d'ensemble de l'architecture : flux de données, composants, choix des runtimes LLM (Ollama vs macMLX) |

---

## 📖 Guides Pratiques

Guides étape par étape pour déployer et configurer les composants.

### 🔧 Setup & Configuration

| Document | Description |
|----------|-------------|
| [**litellm-ollama.md**](guides/setup/litellm-ollama.md) | Configuration LiteLLM + Ollama/macMLX : installation, serveur, performance |
| [**local-macos-agent.md**](guides/setup/local-macos-agent.md) | Agent de relay local sur macOS : connexion Azure Relay, proxy vers LiteLLM |
| [**azure-relay-hybrid-connection.md**](guides/setup/azure-relay-hybrid-connection.md) | Configuration Azure Relay Hybrid Connection : bridge privé Azure ↔ macOS |
| [**azure-https-proxy.md**](guides/setup/azure-https-proxy.md) | Configuration du proxy HTTPS Azure : TLS, auth, rate limiting |
| [**godaddy-dns.md**](guides/setup/godaddy-dns.md) | Configuration DNS GoDaddy : mapping `llm.example.com` vers Azure |

### 🔌 Intégration Client

| Document | Description |
|----------|-------------|
| [**vscode-copilot-byok.md**](guides/integration/vscode-copilot-byok.md) | Intégration VS Code Copilot BYOK : configuration endpoint personnalisé |

---

## 📚 Documentation de Référence

Informations de référence sur la sécurité et les contraintes du projet.

| Document | Description |
|----------|-------------|
| [**security.md**](reference/security.md) | Exigences et recommandations de sécurité : HTTPS, auth, secrets, monitoring |
| [**limitations.md**](reference/limitations.md) | Limitations connues : statut prototype, portée fonctionnelle |

---

## 🗂️ Architecture Decision Records (ADR)

Les décisions architecturales documentées suivant le framework **Michael Nygard**.

| ADR | Titre | Statut | Date |
|-----|-------|--------|------|
| [**000**](adr/000-META-processus-creation-adr.md) | Processus de Création et Gestion des ADR | ✅ Accepté | 2026-06-04 |
| [**001**](adr/001-META-adoption-scrum.md) | Adoption de Scrum pour la gestion du projet | ✅ Accepté | 2026-06-05 |
| [**600**](adr/600-DEVOPS-bootstrap-configuration-management.md) | Bootstrap Configuration Multi-Format | ✅ Accepté | 2026-06-05 |
| [**601**](adr/601-DEVOPS-nomenclature-scripts.md) | Nomenclature Scripts & Makefile | ✅ Accepté | 2026-06-05 |
| [**602**](adr/602-DEVOPS-makefile-orchestrateur.md) | Makefile comme Orchestrateur | ✅ Accepté | 2026-06-05 |
| [**605**](adr/605-DEVOPS-gestion-couleurs-scripts-make.md) | Gestion Couleurs ANSI (Scripts/Make) | ✅ Accepté | 2026-06-05 |
| [**607**](adr/607-DEVOPS-gestion-options-scripts-bash.md) | Gestion Options Scripts Bash | ✅ Accepté | 2026-06-05 |

👉 **Index complet** : [adr/README.md](adr/README.md)

---

## 🚀 Démarrage Rapide

**Pour commencer rapidement**, consultez ces documents dans l'ordre :

1. 📖 [Architecture Overview](architecture/overview.md) — Comprendre le système
2. 🔧 [LiteLLM + Ollama Setup](guides/setup/litellm-ollama.md) — Installer le runtime LLM
3. 🔧 [Local macOS Agent](guides/setup/local-macos-agent.md) — Démarrer l'agent relay
4. 🔧 [Azure Relay Setup](guides/setup/azure-relay-hybrid-connection.md) — Configurer Azure
5. 🔌 [VS Code Integration](guides/integration/vscode-copilot-byok.md) — Connecter VS Code

---

## 🔗 Ressources Externes

- **Projet GitHub** : [michel-heon/private-llm-gateway](https://github.com/michel-heon/private-llm-gateway)
- **Ollama** : [ollama.com](https://ollama.com/)
- **macMLX** : [GitHub - magicnight/mac-mlx](https://github.com/magicnight/mac-mlx)
- **LiteLLM** : [docs.litellm.ai](https://docs.litellm.ai/)
- **Azure Relay** : [Microsoft Docs](https://learn.microsoft.com/azure/azure-relay/)
- **Divio Documentation System** : [documentation.divio.com](https://documentation.divio.com/)

---

## ✏️ Contribuer à la Documentation

Pour améliorer ou ajouter de la documentation :

1. **ADRs** : Suivre le processus dans [ADR-000](adr/000-META-processus-creation-adr.md)
2. **Guides** : Ajouter dans `guides/setup/` ou `guides/integration/`
3. **Référence** : Ajouter dans `reference/` pour documentation statique
4. **Architecture** : Mettre à jour `architecture/overview.md` pour vue d'ensemble

**Commit conventionnel** : `docs: <type> - description courte`

Exemples :
```bash
docs: add troubleshooting guide for relay connection
docs(adr): ADR-603 automated backup strategy
docs(guides): update macMLX performance benchmarks
```

---

_Dernière mise à jour : 2026-06-05_
