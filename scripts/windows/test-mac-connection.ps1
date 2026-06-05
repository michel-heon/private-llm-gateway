# test-mac-connection.ps1
# Script PowerShell pour tester la connexion au serveur macMLX via tunnel SSH
#
# Usage:
#   PowerShell -ExecutionPolicy Bypass -File .\test-mac-connection.ps1
#
# Ou depuis PowerShell:
#   .\test-mac-connection.ps1

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Test de Connexion macMLX" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Configuration
$ENDPOINT = "http://localhost:8080"
$HEALTH_URL = "$ENDPOINT/health"
$MODELS_URL = "$ENDPOINT/v1/models"

# Test 1: Health Check
Write-Host "🔍 Test 1: Health Check..." -ForegroundColor Yellow
Write-Host "   URL: $HEALTH_URL" -ForegroundColor DarkGray

try {
    $response = Invoke-WebRequest -Uri $HEALTH_URL -Method GET -TimeoutSec 5
    
    if ($response.StatusCode -eq 200) {
        $content = $response.Content | ConvertFrom-Json
        Write-Host "✅ Serveur macMLX accessible!" -ForegroundColor Green
        Write-Host "   Status: $($content.status)" -ForegroundColor Green
    } else {
        Write-Host "❌ Erreur HTTP $($response.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Impossible de se connecter au serveur macMLX" -ForegroundColor Red
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Solutions:" -ForegroundColor Yellow
    Write-Host "   1. Vérifiez que le tunnel SSH est actif (autre terminal)" -ForegroundColor White
    Write-Host "      → Commande: ssh -L 8080:localhost:8080 michelheon@192.168.7.116" -ForegroundColor Cyan
    Write-Host "   2. Vérifiez que le serveur macMLX tourne sur le Mac" -ForegroundColor White
    Write-Host "      → SSH vers Mac: ssh michelheon@192.168.7.116" -ForegroundColor Cyan
    Write-Host "      → Puis: cd ~/Developpement/00-GIT/private-llm-gateway && make macmlx-status" -ForegroundColor Cyan
    Write-Host "   3. Si arrêté, démarrer: make macmlx-start" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Appuyez sur Entrée pour quitter"
    exit 1
}

Write-Host ""

# Test 2: List Models
Write-Host "🔍 Test 2: Liste des modèles disponibles..." -ForegroundColor Yellow
Write-Host "   URL: $MODELS_URL" -ForegroundColor DarkGray

try {
    $response = Invoke-WebRequest -Uri $MODELS_URL -Method GET -TimeoutSec 10
    
    if ($response.StatusCode -eq 200) {
        $content = $response.Content | ConvertFrom-Json
        
        Write-Host "✅ Modèles disponibles:" -ForegroundColor Green
        Write-Host ""
        
        $modelCount = 0
        foreach ($model in $content.data) {
            $modelCount++
            Write-Host "   [$modelCount] $($model.id)" -ForegroundColor Cyan
            
            if ($model.id -match "DeepSeek") {
                Write-Host "      → Recommandé pour: Code, debug, refactoring ⭐⭐⭐⭐⭐" -ForegroundColor Green
            } elseif ($model.id -match "Coder") {
                Write-Host "      → Recommandé pour: Code reviews, best practices ⭐⭐⭐⭐⭐" -ForegroundColor Green
            } elseif ($model.id -match "Codestral") {
                Write-Host "      → Recommandé pour: Code production (M2 Max+ requis) ⭐⭐⭐⭐⭐" -ForegroundColor Green
            } elseif ($model.id -match "Qwen2.5-7B") {
                Write-Host "      → Usage général, polyvalent ⭐⭐⭐⭐" -ForegroundColor White
            } elseif ($model.id -match "Mistral") {
                Write-Host "      → Conversationnel, documentation ⭐⭐⭐⭐" -ForegroundColor White
            }
        }
        
        Write-Host ""
        Write-Host "📊 Total: $modelCount modèle(s) chargé(s)" -ForegroundColor Cyan
        
    } else {
        Write-Host "⚠️  Erreur HTTP $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️  Impossible de récupérer la liste des modèles" -ForegroundColor Yellow
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 3: Simple Chat Completion
Write-Host "🔍 Test 3: Test de génération (chat completion)..." -ForegroundColor Yellow
Write-Host "   Question: Quelle est la capitale de la France?" -ForegroundColor DarkGray

$chatBody = @{
    model = "default"
    messages = @(
        @{
            role = "user"
            content = "Quelle est la capitale de la France? Réponds en un mot seulement."
        }
    )
    temperature = 0.1
    max_tokens = 10
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-WebRequest -Uri "$ENDPOINT/v1/chat/completions" -Method POST -Body $chatBody -ContentType "application/json" -TimeoutSec 30
    
    if ($response.StatusCode -eq 200) {
        $content = $response.Content | ConvertFrom-Json
        $answer = $content.choices[0].message.content
        
        Write-Host "✅ Réponse du modèle:" -ForegroundColor Green
        Write-Host "   $answer" -ForegroundColor White
        
        # Statistiques
        if ($content.usage) {
            Write-Host ""
            Write-Host "📊 Statistiques:" -ForegroundColor Cyan
            Write-Host "   Tokens prompt:     $($content.usage.prompt_tokens)" -ForegroundColor White
            Write-Host "   Tokens completion: $($content.usage.completion_tokens)" -ForegroundColor White
            Write-Host "   Tokens total:      $($content.usage.total_tokens)" -ForegroundColor White
        }
        
    } else {
        Write-Host "⚠️  Erreur HTTP $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️  Impossible de générer une réponse" -ForegroundColor Yellow
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Le serveur peut être en train de charger le modèle..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Résumé
Write-Host "📋 Résumé de Configuration VS Code" -ForegroundColor Green
Write-Host ""
Write-Host "Dans VS Code (Windows), ouvrez settings.json:" -ForegroundColor White
Write-Host "   Ctrl + Shift + P → 'Preferences: Open User Settings (JSON)'" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ajoutez cette configuration:" -ForegroundColor White
Write-Host @"
{
  "github.copilot.advanced": {
    "endpoint": "http://localhost:8080/v1",
    "model": "mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit"
  }
}
"@ -ForegroundColor Yellow
Write-Host ""
Write-Host "Puis redémarrez VS Code ou rechargez la fenêtre:" -ForegroundColor White
Write-Host "   Ctrl + Shift + P → 'Developer: Reload Window'" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pour utiliser Copilot:" -ForegroundColor White
Write-Host "   Ctrl + Shift + I → Posez une question" -ForegroundColor Cyan
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Read-Host "Appuyez sur Entrée pour fermer"
