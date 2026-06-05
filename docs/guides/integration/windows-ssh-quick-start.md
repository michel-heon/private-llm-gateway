# Windows → Mac SSH Quick Start

**Guide rapide pour connecter VS Code (Windows 11) au serveur macMLX (Mac) via SSH.**

---

## ⚡ Quick Start (3 étapes)

### 1. Démarrer le tunnel SSH (Windows PowerShell)

```powershell
ssh -L 8080:localhost:8080 michelheon@192.168.7.116
```

**Laissez cette fenêtre ouverte!** Le tunnel reste actif tant que la connexion SSH est active.

### 2. Configurer VS Code (Windows)

Ouvrez `settings.json` (`Ctrl + Shift + P` → "Preferences: Open User Settings (JSON)"):

```json
{
  "github.copilot.advanced": {
    "endpoint": "http://localhost:8080/v1",
    "model": "mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit"
  }
}
```

### 3. Tester

```powershell
# Dans un autre terminal Windows (avec tunnel actif)
curl http://localhost:8080/health
curl http://localhost:8080/v1/models
```

Dans VS Code: `Ctrl + Shift + I` (Copilot Chat) → Poser une question

---

## 🎯 Modèles Disponibles

Changez le champ `"model"` dans `settings.json` avec un de ces identifiants:

| Modèle | Identifiant | Meilleur pour |
|--------|-------------|---------------|
| **DeepSeek-Coder** ⭐ | `mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit` | Code, debug, refactoring |
| **Qwen2.5-Coder-7B** ⭐ | `mlx-community/Qwen2.5-Coder-7B-Instruct-4bit` | Reviews, best practices |
| **Qwen2.5-Coder-14B** | `mlx-community/Qwen2.5-Coder-14B-Instruct-4bit` | Architecture complexe |
| **Codestral-22B** 🚀 | `mlx-community/Codestral-22B-v0.1-4bit` | Production (M2 Max 64GB+) |
| **Qwen2.5-7B** (défaut) | `mlx-community/Qwen2.5-7B-Instruct-4bit` | Polyvalent |
| **Mistral-7B** | `mlx-community/Mistral-7B-Instruct-v0.3-4bit` | Conversationnel |

---

## 🔄 Changer de Modèle

### Sur le Mac (via SSH)

```bash
# Se connecter au Mac
ssh michelheon@192.168.7.116

# Arrêter le serveur actuel
cd ~/Developpement/00-GIT/private-llm-gateway
make macmlx-stop

# Démarrer avec un nouveau modèle (exemple: Codestral-22B)
./scripts/macmlx-start.sh --model mlx-community/Codestral-22B-v0.1-4bit

# Vérifier le statut
make macmlx-status
```

### Sur Windows (VS Code)

1. Modifier `settings.json` (changer le `"model"`)
2. Sauvegarder: `Ctrl + S`
3. Recharger VS Code: `Ctrl + Shift + P` → "Developer: Reload Window"

---

## 🛠️ Troubleshooting

### Le tunnel SSH se ferme automatiquement

**Solution: Ajouter keepalive**

```powershell
ssh -o ServerAliveInterval=60 -L 8080:localhost:8080 michelheon@192.168.7.116
```

### Port 8080 déjà utilisé sur Windows

**Trouver le processus:**
```powershell
netstat -ano | findstr :8080
```

**Tuer le processus:**
```powershell
taskkill /PID <numéro-du-PID> /F
```

**Alternative: Utiliser un autre port**
```powershell
# Tunnel avec port 9080 au lieu de 8080
ssh -L 9080:localhost:8080 michelheon@192.168.7.116

# Puis dans VS Code settings.json:
# "endpoint": "http://localhost:9080/v1"
```

### Mot de passe SSH demandé à chaque connexion

**Solution: Configurer une clé SSH**

```powershell
# 1. Générer une paire de clés (si pas déjà fait)
ssh-keygen -t ed25519 -C "votre_email@example.com"

# 2. Copier la clé publique sur le Mac
type ~\.ssh\id_ed25519.pub | ssh michelheon@192.168.7.116 "cat >> ~/.ssh/authorized_keys"

# 3. Maintenant ssh ne demandera plus de mot de passe
ssh -L 8080:localhost:8080 michelheon@192.168.7.116
```

### Connection refused / Cannot connect

**Vérifier sur le Mac (via SSH séparée):**

```bash
ssh michelheon@192.168.7.116

# Vérifier que le serveur macMLX tourne
make macmlx-status

# Si arrêté, démarrer:
make macmlx-start

# Tester localement sur le Mac:
curl http://127.0.0.1:8080/health
```

**Vérifier sur Windows (avec tunnel actif):**

```powershell
# Tester la connexion locale via le tunnel
curl http://localhost:8080/health

# Si erreur: vérifier que le tunnel SSH est actif
# Redémarrer le tunnel si nécessaire
```

---

## 📋 Workflow Quotidien Recommandé

### Méthode 1: Tunnel Manuel

```powershell
# Terminal 1 (PowerShell): Démarrer le tunnel SSH
ssh -o ServerAliveInterval=60 -L 8080:localhost:8080 michelheon@192.168.7.116
# Laissez ce terminal ouvert toute la journée

# Terminal 2 (PowerShell): Tester la connexion
curl http://localhost:8080/health

# Lancer VS Code
code .
```

### Méthode 2: Script Automatique

Créez un fichier `start-mac-tunnel.ps1`:

```powershell
# start-mac-tunnel.ps1
Write-Host "🚀 Démarrage du tunnel SSH vers Mac..." -ForegroundColor Cyan

# Démarrer le tunnel en background
Start-Process ssh -ArgumentList "-o", "ServerAliveInterval=60", "-L", "8080:localhost:8080", "michelheon@192.168.7.116" -WindowStyle Minimized

# Attendre 3 secondes
Start-Sleep -Seconds 3

# Tester la connexion
Write-Host "🔍 Test de connexion..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/health" -TimeoutSec 5
    Write-Host "✅ Tunnel SSH actif et serveur macMLX connecté!" -ForegroundColor Green
    Write-Host "   → Vous pouvez maintenant utiliser VS Code Copilot" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur de connexion. Vérifiez que le serveur macMLX tourne sur le Mac." -ForegroundColor Red
    Write-Host "   → Connectez-vous au Mac: ssh michelheon@192.168.7.116" -ForegroundColor Yellow
    Write-Host "   → Puis: cd ~/Developpement/00-GIT/private-llm-gateway && make macmlx-start" -ForegroundColor Yellow
}

Read-Host "Appuyez sur Entrée pour continuer..."
```

**Utilisation:**
```powershell
# Exécuter le script
PowerShell -ExecutionPolicy Bypass -File .\start-mac-tunnel.ps1
```

---

## 🎓 Configurations Avancées

### Tunnel Permanent avec AutoSSH

**Installation AutoSSH sur Windows:**
1. Télécharger: https://www.harding.motd.ca/autossh/
2. Extraire `autossh.exe` dans `C:\Program Files\autossh\`
3. Ajouter au PATH Windows

**Utilisation:**
```powershell
autossh -M 0 -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -L 8080:localhost:8080 michelheon@192.168.7.116
```

AutoSSH relance automatiquement le tunnel s'il se ferme.

### Multiple Port Forwarding

Si vous voulez aussi accéder à LiteLLM (port 4000):

```powershell
ssh -L 8080:localhost:8080 -L 4000:localhost:4000 michelheon@192.168.7.116
```

Puis dans VS Code:
```json
{
  "github.copilot.advanced": {
    "endpoint": "http://localhost:4000/v1",
    "model": "qwen2.5-mlx"
  }
}
```

### Config SSH Permanente (Windows)

Créez/éditez `~\.ssh\config`:

```
Host mac-mlx
    HostName 192.168.7.116
    User michelheon
    LocalForward 8080 127.0.0.1:8080
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

**Utilisation simplifiée:**
```powershell
# Au lieu de: ssh -L 8080:localhost:8080 michelheon@192.168.7.116
# Utilisez simplement:
ssh mac-mlx
```

---

## 📚 Ressources

- Guide complet: [vscode-copilot-byok.md](./vscode-copilot-byok.md)
- Setup macMLX: [litellm-ollama.md](../setup/litellm-ollama.md)
- Tests qualité: [../../scrum/sprints/sprint-01/tests/test-codestral-22b-code-quality.md](../../scrum/sprints/sprint-01/tests/test-codestral-22b-code-quality.md)

---

## 🔥 Commandes Rapides

```powershell
# ========================================
# SUR WINDOWS (PowerShell)
# ========================================

# Démarrer tunnel SSH avec keepalive
ssh -o ServerAliveInterval=60 -L 8080:localhost:8080 michelheon@192.168.7.116

# Tester connexion
curl http://localhost:8080/health
curl http://localhost:8080/v1/models

# Vérifier port occupé
netstat -ano | findstr :8080

# Tuer processus
taskkill /PID <PID> /F

# ========================================
# SUR MAC (via SSH ou terminal Mac)
# ========================================

# Se connecter au Mac (autre terminal)
ssh michelheon@192.168.7.116

# Aller dans le projet
cd ~/Developpement/00-GIT/private-llm-gateway

# Vérifier statut
make macmlx-status

# Lister modèles téléchargés
make macmlx-download-status

# Arrêter serveur
make macmlx-stop

# Démarrer serveur (défaut: Qwen2.5-7B)
make macmlx-start

# Démarrer avec modèle spécifique
./scripts/macmlx-start.sh --model mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit

# Télécharger nouveau modèle
make macmlx-download MODEL=mlx-community/Codestral-22B-v0.1-4bit
```

---

## ✅ Checklist de Démarrage

- [ ] Tunnel SSH actif (`ssh -L 8080:localhost:8080 michelheon@192.168.7.116`)
- [ ] Serveur macMLX tourne sur le Mac (`make macmlx-status`)
- [ ] Connexion testée (`curl http://localhost:8080/health` retourne `{"status": "ok"}`)
- [ ] VS Code `settings.json` configuré avec endpoint et model
- [ ] Copilot Chat testé (`Ctrl + Shift + I` → poser une question)
- [ ] Réponses proviennent du modèle local (pas de GitHub API)

**Vous êtes prêt! 🎉**
