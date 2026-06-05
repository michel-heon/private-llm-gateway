#!/bin/bash
#
# start-mac-server-with-tunnel-info.sh
# Démarre le serveur macMLX sur Mac et affiche les instructions pour Windows
#
# Usage:
#   ./scripts/start-mac-server-with-tunnel-info.sh
#   ou
#   make macmlx-start-with-info

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
MAC_USER="${USER}"
MAC_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
PORT="8080"

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  macMLX Server Startup (Mac)${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo ""

# Vérifier si le serveur est déjà actif
if lsof -Pi :${PORT} -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo -e "${YELLOW}⚠️  Le serveur macMLX est déjà actif sur le port ${PORT}${NC}"
    echo ""
    echo -e "${GREEN}Serveur:${NC} http://127.0.0.1:${PORT}"
    echo ""
    
    # Afficher les modèles disponibles
    echo -e "${CYAN}📊 Modèles disponibles:${NC}"
    curl -s http://127.0.0.1:${PORT}/v1/models | python3 -c "
import sys, json
data = json.load(sys.stdin)
for i, model in enumerate(data.get('data', []), 1):
    print(f'  [{i}] {model[\"id\"]}')" 2>/dev/null || echo "  (impossible de récupérer la liste)"
    echo ""
else
    echo -e "${GREEN}🚀 Démarrage du serveur macMLX...${NC}"
    echo ""
    
    # Démarrer le serveur via le script direct (plus rapide que make)
    ./scripts/macmlx-start.sh &
    
    echo -e "${YELLOW}⏳ Attente du démarrage du serveur (10 secondes)...${NC}"
    
    # Attendre que le serveur démarre (max 30 secondes)
    MAX_WAIT=30
    WAITED=0
    while [ $WAITED -lt $MAX_WAIT ]; do
        if lsof -Pi :${PORT} -sTCP:LISTEN -t >/dev/null 2>&1 ; then
            echo -e "${GREEN}✅ Serveur macMLX démarré avec succès!${NC}"
            echo ""
            sleep 2  # Laisser le serveur se stabiliser
            break
        fi
        sleep 2
        WAITED=$((WAITED + 2))
    done
    
    # Vérification finale
    if ! lsof -Pi :${PORT} -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo -e "${RED}❌ Erreur: Le serveur n'a pas démarré dans les ${MAX_WAIT} secondes${NC}"
        echo -e "${YELLOW}   → Vérifiez les logs: make macmlx-logs${NC}"
        echo -e "${YELLOW}   → Ou démarrez manuellement: make macmlx-start${NC}"
        exit 1
    fi
fi

# Afficher les informations de connexion
echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  Informations de Connexion${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${GREEN}📍 Sur ce Mac:${NC}"
echo -e "   Endpoint: ${BLUE}http://127.0.0.1:${PORT}${NC}"
echo -e "   Health:   ${BLUE}http://127.0.0.1:${PORT}/health${NC}"
echo -e "   Models:   ${BLUE}http://127.0.0.1:${PORT}/v1/models${NC}"
echo ""

echo -e "${GREEN}🪟 Pour Windows (via tunnel SSH):${NC}"
echo ""
echo -e "${YELLOW}1. Ouvrir PowerShell sur Windows${NC}"
echo ""
echo -e "${YELLOW}2. Cloner le repo (si pas déjà fait):${NC}"
echo "   git clone https://github.com/michel-heon/private-llm-gateway.git"
echo "   cd private-llm-gateway\\scripts\\windows"
echo ""
echo -e "${YELLOW}3. Démarrer le tunnel SSH:${NC}"
echo "   .\\start-mac-tunnel.ps1"
echo ""
echo -e "   ${CYAN}Ou manuellement:${NC}"
echo "   ssh -L 8080:localhost:8080 ${MAC_USER}@${MAC_IP}"
echo ""
echo -e "${YELLOW}4. Configurer VS Code (Windows):${NC}"
echo "   Ctrl + Shift + P → 'Preferences: Open User Settings (JSON)'"
echo ""
echo '   Ajouter:'
echo '   {'
echo '     "github.copilot.advanced": {'
echo '       "endpoint": "http://localhost:8080/v1",'
echo '       "model": "mlx-community/Codestral-22B-v0.1-4bit"'
echo '     }'
echo '   }'
echo ""
echo -e "${YELLOW}5. Recharger VS Code (Windows):${NC}"
echo "   Ctrl + Shift + P → 'Developer: Reload Window'"
echo ""

echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${GREEN}💡 Commandes Utiles (Mac):${NC}"
echo -e "   ${CYAN}make macmlx-status${NC}        - Vérifier le statut"
echo -e "   ${CYAN}make macmlx-stop${NC}          - Arrêter le serveur"
echo -e "   ${CYAN}make macmlx-logs${NC}          - Voir les logs"
echo -e "   ${CYAN}make macmlx-download-status${NC} - Modèles téléchargés"
echo ""

echo -e "${GREEN}📚 Documentation:${NC}"
echo -e "   ${BLUE}scripts/windows/README.md${NC}"
echo -e "   ${BLUE}docs/guides/integration/windows-ssh-quick-start.md${NC}"
echo ""

# Informations réseau Mac
echo -e "${CYAN}🌐 Informations Réseau (pour debug):${NC}"
echo -e "   IP du Mac:  ${GREEN}${MAC_IP}${NC}"
echo -e "   Utilisateur: ${GREEN}${MAC_USER}${NC}"
echo -e "   Port:       ${GREEN}${PORT}${NC}"
echo ""

echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${GREEN}✅ Prêt! Le serveur macMLX est accessible.${NC}"
echo ""
