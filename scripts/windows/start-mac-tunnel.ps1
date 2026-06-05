# start-mac-tunnel.ps1
# Script PowerShell pour démarrer le tunnel SSH vers macMLX sur Mac
# 
# Usage:
#   PowerShell -ExecutionPolicy Bypass -File .\start-mac-tunnel.ps1
#
# Ou depuis PowerShell:
#   .\start-mac-tunnel.ps1

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  macMLX SSH Tunnel - Windows → Mac (elie-mac)" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Configuration
$MAC_USER = "michelheon"
$MAC_HOST = "192.168.7.116"
$LOCAL_PORT = "8080"
$REMOTE_PORT = "8080"
$SSH_KEY = "$env:USERPROFILE\.ssh\id_ed25519"

# Vérifier si le port local est déjà utilisé
Write-Host "🔍 Vérification du port $LOCAL_PORT..." -ForegroundColor Yellow
$portCheck = Get-NetTCPConnection -LocalPort $LOCAL_PORT -ErrorAction SilentlyContinue

if ($portCheck) {
    Write-Host "⚠️  Port $LOCAL_PORT déjà utilisé par:" -ForegroundColor Red
    Get-Process -Id $portCheck.OwningProcess | Select-Object Id, ProcessName, StartTime | Format-Table -AutoSize
    
    $response = Read-Host "Voulez-vous tuer ce processus et continuer? (o/n)"
    if ($response -eq "o" -or $response -eq "O") {
        Write-Host "🔪 Arrêt du processus..." -ForegroundColor Yellow
        Stop-Process -Id $portCheck.OwningProcess -Force
        Start-Sleep -Seconds 2
        Write-Host "✅ Processus arrêté" -ForegroundColor Green
    } else {
        Write-Host "❌ Annulé. Changez le port LOCAL_PORT dans le script ou libérez le port." -ForegroundColor Red
        Read-Host "Appuyez sur Entrée pour quitter..."
        exit 1
    }
}

# Vérifier si une clé SSH existe
Write-Host "🔑 Vérification de la clé SSH..." -ForegroundColor Yellow
if (Test-Path $SSH_KEY) {
    Write-Host "✅ Clé SSH trouvée: $SSH_KEY" -ForegroundColor Green
    $USE_KEY = "-i `"$SSH_KEY`""
} else {
    Write-Host "⚠️  Aucune clé SSH trouvée. Connexion par mot de passe." -ForegroundColor Yellow
    Write-Host "   Pour éviter de taper le mot de passe à chaque fois:" -ForegroundColor Cyan
    Write-Host "   1. Générez une clé: ssh-keygen -t ed25519 -C `"votre_email@example.com`"" -ForegroundColor Cyan
    Write-Host "   2. Copiez-la sur le Mac: type ~\.ssh\id_ed25519.pub | ssh $MAC_USER@$MAC_HOST `"cat >> ~/.ssh/authorized_keys`"" -ForegroundColor Cyan
    Write-Host ""
    $USE_KEY = ""
}

# Construire la commande SSH
$SSH_CMD = "ssh"
$SSH_ARGS = @(
    "-o", "ServerAliveInterval=60",
    "-o", "ServerAliveCountMax=3",
    "-L", "${LOCAL_PORT}:localhost:${REMOTE_PORT}"
)

if ($USE_KEY) {
    $SSH_ARGS += @("-i", $SSH_KEY)
}

$SSH_ARGS += "${MAC_USER}@${MAC_HOST}"

Write-Host "🚀 Démarrage du tunnel SSH..." -ForegroundColor Cyan
Write-Host "   Commande: ssh -L ${LOCAL_PORT}:localhost:${REMOTE_PORT} ${MAC_USER}@${MAC_HOST}" -ForegroundColor DarkGray
Write-Host ""
Write-Host "⚠️  IMPORTANT: Laissez cette fenêtre ouverte!" -ForegroundColor Yellow
Write-Host "   Le tunnel reste actif tant que cette connexion SSH est active." -ForegroundColor Yellow
Write-Host ""
Write-Host "📋 Une fois connecté:" -ForegroundColor Green
Write-Host "   1. Ouvrez un AUTRE terminal PowerShell" -ForegroundColor White
Write-Host "   2. Testez la connexion: curl http://localhost:8080/health" -ForegroundColor White
Write-Host "   3. Lancez VS Code et utilisez Copilot (Ctrl+Shift+I)" -ForegroundColor White
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Démarrer le tunnel SSH (mode interactif)
& $SSH_CMD @SSH_ARGS

# Si le tunnel se ferme, afficher un message
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Red
Write-Host "⚠️  Tunnel SSH fermé" -ForegroundColor Red
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Red
Write-Host ""
Write-Host "Causes possibles:" -ForegroundColor Yellow
Write-Host "  - Connexion réseau perdue" -ForegroundColor White
Write-Host "  - Mac éteint ou endormi" -ForegroundColor White
Write-Host "  - Déconnexion manuelle (Ctrl+D ou exit)" -ForegroundColor White
Write-Host ""
Write-Host "Pour redémarrer le tunnel, relancez ce script." -ForegroundColor Green
Write-Host ""

Read-Host "Appuyez sur Entrée pour fermer cette fenêtre"
