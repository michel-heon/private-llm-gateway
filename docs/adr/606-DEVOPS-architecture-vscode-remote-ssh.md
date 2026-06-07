---
# 🤖 Machine-Readable Metadata (Frontmatter YAML)
adr: 606
title: "Architecture VS Code Remote SSH - Windows VM vers Mac"
status: "accepted"
date: 2026-06-07
superseded_by: null
replaces: null
related_adrs: [600, 601, 602]
related_issues: []

# 🗂️ Taxonomie ADR
classification:
  lifecycle: "accepted"
  domain: "devops"
  impact: "high"
  quality:
    - "maintainability"
    - "usability"
    - "portability"
  reversibility: "moderate"
  scope: "tactical"
  tech_areas:
    - "vscode"
    - "ssh"
    - "parallels-desktop"
    - "macos"
    - "windows"
    - "remote-development"

tags: ["vscode", "remote-ssh", "parallels-desktop", "development-environment", "vm", "configuration-management"]
stakeholders: ["@dev-team", "@private-llm-gateway"]
effort: "low"
---

# ADR 606: Architecture VS Code Remote SSH - Windows VM vers Mac

## 📊 Vue d'Ensemble

| Attribut | Valeur |
|----------|--------|
| **Statut** | ✅ Accepté |
| **Date Décision** | 2026-06-07 |
| **Stakeholders** | @dev-team |
| **Impact** | 🔴 Élevé (affects configuration strategy) |
| **Effort Implémentation** | 🟢 Faible (déjà en place) |
| **Risque Technique** | 🟢 Faible |

---

## 🎯 Contexte & Problème

### Architecture Actuelle

Le projet **Private LLM Gateway** est développé dans un environnement de développement hybride:

1. **Machine physique**: MacBook (hostname: `elie-mac`, IP: `192.168.7.116`)
   - OS: macOS (Apple Silicon M1/M2/M3/M4)
   - Réseau: Interface `en0` en mode bridge/shared
   - Rôle: Serveur d'exécution (Python, macMLX, LiteLLM, scripts bash)

2. **Machine virtuelle**: Windows 11 dans Parallels Desktop
   - Hôte: Même MacBook physique
   - Mode réseau: Partagé (shared network) - la VM et le Mac partagent le même réseau local
   - VS Code UI: Installé sur Windows
   - Rôle: Interface utilisateur de développement

3. **Connexion**: VS Code Remote SSH
   - Windows VS Code UI → SSH → Mac backend
   - Extensions VS Code: S'exécutent sur le Mac (serveur SSH)
   - Terminal intégré: Shell bash sur Mac

### Le Problème de Split-Brain Configuration

Cette architecture crée une **dualité de configuration** problématique:

| Configuration | Localisation Windows | Localisation Mac | Responsabilité |
|---------------|---------------------|------------------|----------------|
| `settings.json` (UI) | `C:/Users/MichelHéonCotechnoe/AppData/Roaming/Code/User/` | `/Users/michelheon/Library/Application Support/Code/User/` | UI: Windows, Extensions: Mac |
| `chatLanguageModels.json` | `C:/Users/MichelHéonCotechnoe/AppData/Roaming/Code/User/` | N/A | Copilot Chat UI (Windows) |
| Extensions | Windows: installation, Mac: exécution | Remote SSH Server | Extensions backend sur Mac |
| Terminal (cwd, env) | N/A | Mac filesystem | Shell bash sur Mac |

**Problèmes rencontrés:**

1. **Confusion settings.json**: L'utilisateur modifie les settings sur Mac pensant configurer l'UI Windows
2. **chatLanguageModels.json invisible**: Fichier uniquement sur Windows, inaccessible via SSH depuis Mac
3. **Model pinning issues**: Custom endpoint models dans Foundry Toolkit ne se comportent pas comme les modèles natifs
4. **Network endpoint confusion**: Modèles pointent vers `http://192.168.7.116:8080` (Mac) mais configurés depuis Windows

### Questions Guidées

**1. Quel problème essayons-nous de résoudre?**
- Documenter clairement quelle configuration vit où (Windows UI vs Mac backend)
- Éviter les erreurs de configuration (modifier le mauvais settings.json)
- Guider les développeurs et agents IA sur l'architecture split Windows/Mac

**2. Quelles sont les contraintes et exigences?**
- **Techniques**: VS Code Remote SSH impose une architecture client/serveur
- **Réseau**: Windows VM et Mac partagent le même réseau local (Parallels shared mode)
- **Performance**: UI réactive sur Windows malgré SSH overhead
- **Compatibilité**: Extensions doivent s'exécuter sur Mac pour accéder au code

**3. Quel est l'impact si nous ne documentons pas cette décision?**
- **Court terme**: Confusion répétée sur quel fichier modifier (perte de temps)
- **Moyen terme**: Bugs intermittents liés à la mauvaise configuration
- **Long terme**: Onboarding difficile pour nouveaux développeurs

**4. Quels facteurs influencent cette décision?**
- **Architecture VS Code Remote SSH**: Imposée par Microsoft, non négociable
- **Parallels Desktop**: VM Windows sur Mac physique, optimal pour développement hybride
- **macMLX**: Nécessite Apple Silicon, doit tourner sur Mac
- **GitHub Copilot**: UI composante (Chat Panel) tourne côté client (Windows)

---

## ✅ Décision

### Approche Choisie

Nous **acceptons et documentons** l'architecture **VS Code Remote SSH avec Windows UI sur Mac backend** comme configuration standard du projet. Cette architecture est traitée comme un **fait établi** plutôt qu'une décision active, mais nécessite une documentation explicite pour éviter les confusions.

### Règles de Configuration

#### 1. Settings UI-Related (Windows)

**Fichier**: `C:/Users/MichelHéonCotechnoe/AppData/Roaming/Code/User/settings.json` (Windows)

**Contenu géré**:
- `workbench.*` (thème, colorScheme, UI layout)
- `editor.fontSize`, `editor.fontFamily` (rendu UI)
- **GitHub Copilot Chat UI settings** (si elles existent dans `settings.json`)

**Accès**: Modifier via Windows uniquement
- `Ctrl+Shift+P` → "Preferences: Open User Settings (JSON)" (depuis Windows VS Code)

#### 2. Extensions Backend Settings (Mac)

**Fichier**: `/Users/michelheon/Library/Application Support/Code/User/settings.json` (Mac)

**Contenu géré**:
- Extensions s'exécutant sur le serveur SSH (Python, Bash, Git)
- `terminal.integrated.*` (shell sur Mac)
- `remote.SSH.*` (configuration SSH)
- **IMPORTANT**: ~~`github.copilot.advanced`~~ **ne doit PAS être ici** (approche abandonnée, voir ADR note)

**Accès**: Modifier via SSH ou directement sur Mac
```bash
# Depuis le terminal intégré VS Code (qui tourne sur Mac)
code ~/Library/Application\ Support/Code/User/settings.json
```

#### 3. Foundry Toolkit Custom Endpoints (Windows)

**Fichier**: `C:/Users/MichelHéonCotechnoe/AppData/Roaming/Code/User/chatLanguageModels.json` (Windows)

**Contenu**:
```json
{
  "name": "macMLX Local",
  "vendor": "customendpoint",
  "apiKey": "dummy",
  "apiType": "chat-completions",
  "models": [
    {
      "name": "Codestral 22B (macMLX)",
      "url": "http://192.168.7.116:8080/v1/chat/completions",
      "toolCalling": false,
      "vision": false,
      "maxInputTokens": 32000,
      "maxOutputTokens": 4096,
      "id": "mlx-community/Codestral-22B-v0.1-4bit"
    },
    {
      "name": "Qwen2.5 7B (macMLX)",
      "url": "http://192.168.7.116:8080/v1/chat/completions",
      "id": "mlx-community/Qwen2.5-7B-Instruct-4bit"
    }
  ]
}
```

**Accès**: Uniquement via Windows
- Via UI: Foundry Toolkit → "Add Models..." → "Custom Endpoint"
- Direct: PowerShell sur Windows
  ```powershell
  notepad "$env:APPDATA\Code\User\chatLanguageModels.json"
  ```

#### 4. Network Endpoints

**macMLX Server**: Tourne sur Mac (`elie-mac`)
- Host: `0.0.0.0` (bind sur toutes interfaces réseau)
- Port: `8080`
- Endpoint depuis Windows: `http://192.168.7.116:8080` (IP Mac sur réseau local)
- Endpoint depuis Mac: `http://127.0.0.1:8080` (localhost)

**Configuration réseau requise**: Parallels Desktop en mode "Shared Network" (déjà configuré)

### Diagramme Architecture

```
┌─────────────────────────────────────────────────────────────┐
│ MacBook Physique (elie-mac) - Apple Silicon M1/M2/M3/M4    │
│ IP: 192.168.7.116 (en0)                                     │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Windows 11 VM (Parallels Desktop)                    │  │
│  │ Mode réseau: Shared                                  │  │
│  │                                                       │  │
│  │  ┌───────────────────────────────────────────────┐  │  │
│  │  │ VS Code UI (Windows Native)                   │  │  │
│  │  │                                                │  │  │
│  │  │ • Chat Panel (Copilot UI)                     │  │  │
│  │  │ • Language Models Dropdown                    │  │  │
│  │  │ • Editor Rendering                            │  │  │
│  │  │                                                │  │  │
│  │  │ Config: settings.json (Windows)               │  │  │
│  │  │         chatLanguageModels.json (Windows)     │  │  │
│  │  └───────────────┬───────────────────────────────┘  │  │
│  │                  │ SSH (port 22)                     │  │
│  └──────────────────┼───────────────────────────────────┘  │
│                     ▼                                       │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ macOS Host (SSH Server)                             │   │
│  │                                                      │   │
│  │ • VS Code Remote SSH Server                         │   │
│  │ • Extensions Backend (Python, Bash, Git)            │   │
│  │ • Terminal Shell (bash)                             │   │
│  │ • Workspace Files (/Users/michelheon/...)           │   │
│  │                                                      │   │
│  │ Config: settings.json (Mac - extensions)            │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ macMLX Server (Python 3.9)                          │   │
│  │                                                      │   │
│  │ • mlx_lm.server (port 8080)                         │   │
│  │ • Bind: 0.0.0.0 (accessible from Windows VM)        │   │
│  │ • Models: Qwen2.5-7B, Codestral-22B, etc.          │   │
│  │                                                      │   │
│  │ Endpoint: http://192.168.7.116:8080                 │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘

       HTTP Requests ←──────────────────────────────┘
       (chatLanguageModels.json → macMLX server)
```

### Comment Cette Solution Résout le Problème

1. **Confusion settings.json** → Résolu par documentation claire des responsabilités
   - Settings UI: Windows uniquement
   - Settings Extensions: Mac uniquement
   - Règle: Pas de configuration GitHub Copilot dans settings.json Mac

2. **chatLanguageModels.json invisible** → Résolu par documentation de l'approche Windows-only
   - Fichier géré exclusivement sur Windows (pas accessible via SSH)
   - Modification via Foundry Toolkit UI ou PowerShell sur Windows

3. **Network endpoint confusion** → Résolu par documentation IP explicite
   - Windows vers Mac: `http://192.168.7.116:8080`
   - Mac localhost: `http://127.0.0.1:8080`
   - Parallels Shared Network: Bridge automatique

### Principes Architecturaux Appliqués

- ✅ **Separation of Concerns**: UI (Windows) vs Backend (Mac)
- ✅ **Location Transparency**: Extensions backend ignorent qu'elles tournent en remote
- ✅ **Configuration Consistency**: Un seul fichier par responsabilité (pas de duplication)
- ✅ **Development Experience**: Environment hybride optimal pour Apple Silicon + Windows UI

### Technologies/Outils Utilisées

| Technologie | Version | Rôle | Justification |
|-------------|---------|------|---------------|
| VS Code | Latest stable | IDE multi-plateforme | Remote SSH support natif |
| Remote SSH Extension | Latest | Client/Server architecture | Split UI/Backend officiel Microsoft |
| Parallels Desktop | Latest | Virtualisation macOS | Performance native, shared network |
| macOS | Latest (Apple Silicon) | Backend execution | macMLX requirement |
| Windows 11 | Latest | UI client | Familiarité utilisateur |
| SSH | OpenSSH | Remote connection | Standard sécurisé |

---

## 🔄 Alternatives Considérées

### Alternative 1: VS Code natif sur Mac uniquement

**Description**: Tout sur Mac, pas de Windows VM

**Avantages**:
- ✅ Pas de split configuration
- ✅ Pas de overhead SSH
- ✅ Simplicité setup

**Inconvénients**:
- ❌ Perte de familiarité Windows UI
- ❌ Pas de test cross-platform
- ❌ Workflow utilisateur actuel perturbé

**Raison du rejet**: L'utilisateur préfère Windows UI, setup déjà en place

---

### Alternative 2: VS Code natif sur Windows + SSH manuel vers Mac

**Description**: VS Code sur Windows sans Remote SSH, SSH manuel en terminal

**Avantages**:
- ✅ Toutes configs sur Windows
- ✅ Contrôle SSH total

**Inconvénients**:
- ❌ Pas d'intégration IDE (IntelliSense, debugging remote)
- ❌ Workflow cassé (copier/coller code entre machines)
- ❌ Perte des extensions backend

**Raison du rejet**: Perte majeure de productivité sans Remote SSH

---

### Alternative 3: Dev Container sur Mac

**Description**: VS Code + Docker Dev Container sur Mac uniquement

**Avantages**:
- ✅ Environment reproductible
- ✅ Isolation dépendances

**Inconvénients**:
- ❌ macMLX nécessite accès direct Apple Silicon (pas de virtualisation)
- ❌ Overhead Docker sur macOS
- ❌ Complexité setup

**Raison du rejet**: macMLX incompatible avec Docker (nécessite Metal direct)

---

## ⚠️ Conséquences

### Positives ✅

1. **Clarté configuration**: Documentation explicite évite les erreurs
2. **Best of both worlds**: Windows UI familier + Mac Apple Silicon performance
3. **Développement efficace**: Remote SSH = expérience native
4. **Network transparency**: Shared network Parallels = pas de port forwarding complexe

### Négatives ⚠️

1. **Split-brain configuration**: Deux fichiers settings.json (un par machine)
2. **chatLanguageModels.json inaccessible**: Pas de modification via SSH depuis Mac
3. **Debugging confusion**: Nécessite compréhension architecture pour troubleshooting
4. **Documentation overhead**: Nouveaux développeurs doivent lire cette ADR

### Risques 🔴

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| Confusion configuration | Moyenne | Moyen | Cette ADR + documentation inline |
| SSH connection loss | Faible | Faible | Reconnect automatique VS Code |
| Network change (IP change) | Faible | Moyen | DHCP reservation ou hostname |
| Extension incompatibilité | Faible | Faible | Test extensions avant déploiement |

---

## 📋 Checklist d'Implémentation

- [x] Architecture déjà en place (fait établi)
- [x] macMLX daemon scripts créés (survive VS Code reload)
- [x] chatLanguageModels.json configuré sur Windows
- [x] Documentation scripts/README.md mise à jour
- [ ] **Ajouter cette ADR au README.md** (obligatoire)
- [ ] Créer guide onboarding pour nouveaux développeurs
- [ ] Documenter troubleshooting SSH connection issues

---

## 🔗 Références

### Documentation Projet

- [scripts/README.md](../../scripts/README.md) - Scripts macMLX (Mac)
- [scripts/windows/README.md](../../scripts/windows/README.md) - Scripts Windows
- [docs/guides/integration/vscode-copilot-byok.md](../../guides/integration/vscode-copilot-byok.md) - Configuration Copilot

### Standards & Best Practices

- [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)
- [Remote SSH Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)
- [Parallels Desktop Networking](https://kb.parallels.com/en/4948)

### Outils

- [Foundry Toolkit Extension](https://marketplace.visualstudio.com/items?itemName=ms-windows-ai-studio.windows-ai-studio)
- [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [macMLX Documentation](https://github.com/ml-explore/mlx-examples/tree/main/llms)

---

## 📝 Notes & Contexte Historique

### Évolution Configuration Copilot

1. **Tentative 1**: `github.copilot.advanced` dans settings.json (Mac)
   - **Résultat**: Échec, utilisateur a dit "tu as halluciné cette solution"
   - **Raison**: Settings UI gérées côté Windows, pas Mac

2. **Tentative 2**: `github.copilot.advanced` dans settings.json (Windows)
   - **Résultat**: Rejeté par utilisateur ("Oublie cette approche")
   - **Raison**: Configuration cachée, pas dans l'UI

3. **Solution finale**: `chatLanguageModels.json` via Foundry Toolkit
   - **Résultat**: ✅ Modèles apparaissent dans Language Models panel
   - **Limitation**: Modèles custom endpoint pas pinnable (comportement natif Foundry Toolkit)

### Issue Pinning (Non Résolu)

**Symptôme**: Modèles macMLX apparaissent dans Language Models panel mais ne sont pas "pinnable"

**Cause probable**: Custom endpoint models dans Foundry Toolkit se comportent différemment des modèles natifs (GitHub Copilot, Foundry hosted models)

**Status**: Documentation officielle GitHub Copilot ne couvre pas explicitement le pinning behavior de chatLanguageModels.json custom endpoints

**Prochaines étapes**: 
- [ ] Vérifier si Foundry Toolkit a un attribut `pinnable: true` dans chatLanguageModels.json
- [ ] Tester si models array order affecte le pinning
- [ ] Investiguer si c'est une limitation intentionnelle des custom endpoints

---

_Création : 2026-06-07_  
_Dernière mise à jour : 2026-06-07_
