# Scripts PowerShell pour Windows

Scripts PowerShell pour connecter VS Code (Windows 11) au serveur macMLX (Mac) via tunnel SSH.

## 📋 Liste des Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `start-mac-tunnel.ps1` | Démarre le tunnel SSH vers le Mac | Principal - À lancer en premier |
| `test-mac-connection.ps1` | Teste la connexion au serveur macMLX | Diagnostic et validation |

---

## 🚀 Quick Start (3 étapes)

### 1. Démarrer le Tunnel SSH

**Double-cliquez sur `start-mac-tunnel.ps1`** ou depuis PowerShell:

```powershell
cd scripts\windows
.\start-mac-tunnel.ps1
```

**⚠️ IMPORTANT:** Laissez cette fenêtre ouverte! Le tunnel reste actif tant que la connexion SSH est active.

### 2. Tester la Connexion (dans un autre terminal)

```powershell
cd scripts\windows
.\test-mac-connection.ps1
```

Ce script vérifie:
- ✅ Health check (`/health`)
- ✅ Liste des modèles disponibles (`/v1/models`)
- ✅ Génération de texte (chat completion)

### 3. Configurer VS Code

Ouvrez `settings.json` dans VS Code:
- `Ctrl + Shift + P` → "Preferences: Open User Settings (JSON)"

Ajoutez:
```json
{
  "github.copilot.advanced": {
    "endpoint": "http://localhost:8080/v1",
    "model": "mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit"
  }
}
```

Sauvegardez (`Ctrl + S`) et rechargez VS Code:
- `Ctrl + Shift + P` → "Developer: Reload Window"

**C'est tout!** Utilisez Copilot normalement (`Ctrl + Shift + I` pour le Chat).

---

## 📖 Détails des Scripts

### `start-mac-tunnel.ps1`

**Fonctionnalités:**
- ✅ Vérifie si le port 8080 est déjà utilisé
- ✅ Propose de tuer le processus qui utilise le port
- ✅ Détecte automatiquement la clé SSH (`~/.ssh/id_ed25519`)
- ✅ Configure keepalive pour éviter les déconnexions (`ServerAliveInterval=60`)
- ✅ Affiche des instructions claires après connexion
- ✅ Message explicite si le tunnel se ferme

**Configuration (éditable dans le script):**
```powershell
$MAC_USER = "michelheon"           # Utilisateur SSH sur le Mac
$MAC_HOST = "192.168.7.116"        # IP du Mac
$LOCAL_PORT = "8080"               # Port local Windows
$REMOTE_PORT = "8080"              # Port macMLX sur le Mac
$SSH_KEY = "$env:USERPROFILE\.ssh\id_ed25519"  # Clé SSH
```

**Commande SSH générée:**
```powershell
ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -L 8080:localhost:8080 michelheon@192.168.7.116
```

### `test-mac-connection.ps1`

**Tests effectués:**

1. **Health Check**
   - Endpoint: `http://localhost:8080/health`
   - Vérifie que le serveur répond
   - Affiche le statut (`{"status": "ok"}`)

2. **Liste des Modèles**
   - Endpoint: `http://localhost:8080/v1/models`
   - Liste tous les modèles chargés
   - Affiche les recommandations d'usage

3. **Chat Completion**
   - Endpoint: `http://localhost:8080/v1/chat/completions`
   - Test de génération avec question simple
   - Affiche les statistiques de tokens

**Si le test échoue, le script propose:**
- ✅ Vérifier que le tunnel SSH est actif
- ✅ Se connecter au Mac et vérifier `make macmlx-status`
- ✅ Démarrer le serveur si nécessaire: `make macmlx-start`

---

## 🔧 Troubleshooting

### Erreur: "Port 8080 déjà utilisé"

**Solution automatique:**
Le script `start-mac-tunnel.ps1` détecte cette situation et propose:
1. D'afficher quel processus utilise le port
2. De tuer ce processus automatiquement

**Solution manuelle:**
```powershell
# Trouver le processus
netstat -ano | findstr :8080

# Tuer le processus (remplacer <PID>)
taskkill /PID <PID> /F
```

**Alternative: Utiliser un autre port**

Éditez `start-mac-tunnel.ps1` et changez:
```powershell
$LOCAL_PORT = "9080"  # Au lieu de 8080
```

Puis dans VS Code `settings.json`:
```json
{
  "github.copilot.advanced": {
    "endpoint": "http://localhost:9080/v1",
    ...
  }
}
```

### Tunnel SSH se ferme automatiquement

**Le script inclut déjà keepalive**, mais si ça persiste:

1. **Vérifiez la connexion réseau** (WiFi stable?)
2. **Vérifiez que le Mac ne s'endort pas:**
   - Sur Mac: Réglages Système → Économiseur d'énergie
   - Désactiver "Mettre en veille les disques durs"
   - Augmenter le délai avant veille

3. **Utilisez AutoSSH (Windows):**
   - Téléchargez: https://www.harding.motd.ca/autossh/
   - Installez `autossh.exe` dans `C:\Program Files\autossh\`
   - Utilisez:
     ```powershell
     autossh -M 0 -o "ServerAliveInterval 60" -L 8080:localhost:8080 michelheon@192.168.7.116
     ```

### Mot de passe SSH demandé à chaque fois

**Configurez une authentification par clé SSH:**

```powershell
# 1. Générer une paire de clés (si pas déjà fait)
ssh-keygen -t ed25519 -C "votre_email@example.com"

# 2. Copier la clé publique sur le Mac
type ~\.ssh\id_ed25519.pub | ssh michelheon@192.168.7.116 "cat >> ~/.ssh/authorized_keys"

# 3. Tester (ne doit plus demander de mot de passe)
ssh michelheon@192.168.7.116
```

Le script `start-mac-tunnel.ps1` détecte automatiquement la clé.

### "Invoke-WebRequest" commande introuvable

**Windows 7/8 (ancien PowerShell):**

Utilisez `curl.exe` à la place:
```powershell
curl.exe http://localhost:8080/health
```

Ou mettez à jour PowerShell:
- Téléchargez PowerShell 7: https://github.com/PowerShell/PowerShell/releases

### Erreur "Execution Policy"

**Si Windows bloque l'exécution des scripts:**

```powershell
# Option 1: Bypass temporaire (recommandé)
PowerShell -ExecutionPolicy Bypass -File .\start-mac-tunnel.ps1

# Option 2: Changer la politique (permanent, nécessite admin)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 🎯 Modèles Disponibles

Changez le champ `"model"` dans VS Code `settings.json`:

| Modèle | Identifiant | Taille | Meilleur pour |
|--------|-------------|--------|---------------|
| **DeepSeek-Coder** ⭐⭐⭐⭐⭐ | `mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit` | 4GB | Code, debug, refactoring |
| **Qwen2.5-Coder-7B** ⭐⭐⭐⭐⭐ | `mlx-community/Qwen2.5-Coder-7B-Instruct-4bit` | 4GB | Reviews, best practices |
| **Qwen2.5-Coder-14B** ⭐⭐⭐⭐⭐ | `mlx-community/Qwen2.5-Coder-14B-Instruct-4bit` | 8GB | Architecture complexe |
| **Codestral-22B** ⭐⭐⭐⭐⭐ | `mlx-community/Codestral-22B-v0.1-4bit` | 14GB | Production (M2 Max 64GB+) |
| Qwen2.5-7B (défaut) | `mlx-community/Qwen2.5-7B-Instruct-4bit` | 4GB | Polyvalent |
| Mistral-7B | `mlx-community/Mistral-7B-Instruct-v0.3-4bit` | 4GB | Conversationnel |

**Pour changer de modèle:**

1. **Sur le Mac** (via SSH ou terminal Mac direct):
   ```bash
   cd ~/Developpement/00-GIT/private-llm-gateway
   make macmlx-stop
   ./scripts/macmlx-start.sh --model mlx-community/Codestral-22B-v0.1-4bit
   ```

2. **Sur Windows** (VS Code `settings.json`):
   ```json
   {
     "github.copilot.advanced": {
       "endpoint": "http://localhost:8080/v1",
       "model": "mlx-community/Codestral-22B-v0.1-4bit"
     }
   }
   ```

3. **Recharger VS Code:**
   - `Ctrl + Shift + P` → "Developer: Reload Window"

---

## 📚 Documentation Complète

- **Quick Start SSH:** [../../docs/guides/integration/windows-ssh-quick-start.md](../../docs/guides/integration/windows-ssh-quick-start.md)
- **Guide Complet BYOK:** [../../docs/guides/integration/vscode-copilot-byok.md](../../docs/guides/integration/vscode-copilot-byok.md)
- **Setup macMLX:** [../../docs/guides/setup/litellm-ollama.md](../../docs/guides/setup/litellm-ollama.md)
- **Tests Qualité:** [../../docs/scrum/sprints/sprint-01/tests/test-codestral-22b-code-quality.md](../../docs/scrum/sprints/sprint-01/tests/test-codestral-22b-code-quality.md)

---

## 🔒 Sécurité

### Clés SSH

- ✅ **Recommandé:** Utilisez des clés Ed25519 (modernes, sécurisées)
- ✅ Protégez votre clé privée avec une passphrase
- ✅ Ne partagez JAMAIS votre clé privée (`id_ed25519`)
- ✅ Seule la clé publique (`id_ed25519.pub`) doit être copiée sur le Mac

### Tunnel SSH

- ✅ Le tunnel SSH chiffre toutes les communications
- ✅ Seul localhost (127.0.0.1) peut accéder au port forwardé
- ✅ Le serveur macMLX n'est pas exposé sur le réseau local
- ⚠️ Ne partagez pas votre tunnel SSH avec d'autres machines

### VS Code Settings

- ✅ Les `settings.json` sont locaux à votre machine
- ✅ Pas d'API key nécessaire (endpoint local)
- ⚠️ Ne commitez pas `settings.json` dans un repo public si vous utilisez des endpoints avec API keys

---

## 💡 Workflow Quotidien Recommandé

**Matin:**
```powershell
# 1. Démarrer le tunnel SSH
cd C:\path\to\private-llm-gateway\scripts\windows
.\start-mac-tunnel.ps1
# Laissez cette fenêtre ouverte toute la journée

# 2. Tester la connexion (autre terminal)
.\test-mac-connection.ps1

# 3. Lancer VS Code
code .
```

**Pendant la journée:**
- Utilisez Copilot normalement (`Ctrl + Shift + I`)
- Le tunnel reste actif en arrière-plan
- Si déconnexion: relancez `start-mac-tunnel.ps1`

**Soir:**
- Fermez la fenêtre du tunnel SSH (`Ctrl + C` ou fermez le terminal)
- Le serveur macMLX sur le Mac peut rester actif (utilise peu de ressources)

---

## 🎓 Configuration Avancée

### Config SSH Permanente

Créez/éditez `~\.ssh\config` (Windows):

```
Host mac-mlx
    HostName 192.168.7.116
    User michelheon
    LocalForward 8080 127.0.0.1:8080
    ServerAliveInterval 60
    ServerAliveCountMax 3
    IdentityFile ~/.ssh/id_ed25519
```

**Utilisation simplifiée:**
```powershell
# Au lieu de tout taper, utilisez simplement:
ssh mac-mlx
```

### Multiple Port Forwarding

Pour accéder aussi à LiteLLM (port 4000):

```powershell
ssh -L 8080:localhost:8080 -L 4000:localhost:4000 michelheon@192.168.7.116
```

Ou dans `~\.ssh\config`:
```
Host mac-mlx
    HostName 192.168.7.116
    User michelheon
    LocalForward 8080 127.0.0.1:8080
    LocalForward 4000 127.0.0.1:4000
    ServerAliveInterval 60
```

### Tunnel en Background (Task Scheduler)

Pour lancer le tunnel automatiquement au démarrage de Windows:

1. Ouvrez **Task Scheduler** (Planificateur de tâches)
2. Créez une nouvelle tâche:
   - **Trigger:** "At log on"
   - **Action:** Start a program
   - **Program:** `powershell.exe`
   - **Arguments:** `-WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\path\to\start-mac-tunnel.ps1"`
3. Cochez "Run whether user is logged on or not"

---

## ✅ Checklist de Configuration Initiale

### Configuration SSH (une fois)

- [ ] Générer clé SSH: `ssh-keygen -t ed25519`
- [ ] Copier clé publique sur Mac: `type ~\.ssh\id_ed25519.pub | ssh michelheon@192.168.7.116 "cat >> ~/.ssh/authorized_keys"`
- [ ] Tester connexion sans mot de passe: `ssh michelheon@192.168.7.116`
- [ ] Créer `~\.ssh\config` pour alias `mac-mlx` (optionnel)

### Configuration VS Code (une fois)

- [ ] Installer GitHub Copilot extension
- [ ] Ouvrir `settings.json` (`Ctrl + Shift + P` → "Preferences: Open User Settings (JSON)")
- [ ] Ajouter configuration `github.copilot.advanced` avec endpoint et model
- [ ] Sauvegarder (`Ctrl + S`)
- [ ] Recharger VS Code (`Ctrl + Shift + P` → "Developer: Reload Window")

### Vérification (à chaque utilisation)

- [ ] Serveur macMLX actif sur Mac (`make macmlx-status`)
- [ ] Tunnel SSH démarré (`start-mac-tunnel.ps1`)
- [ ] Connexion testée (`test-mac-connection.ps1`)
- [ ] Copilot répond dans VS Code (`Ctrl + Shift + I`)

---

**Vous êtes prêt! 🎉**

Pour toute question, consultez la [documentation complète](../../docs/guides/integration/vscode-copilot-byok.md).
