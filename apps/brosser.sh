#!/usr/bin/env bash
set -euo pipefail

echo "[APPS] Installation de navigateurs durcis..."

# Firefox est déjà présent en général, mais on peut ajouter des profils durcis plus tard.
# Exemple : installation de Brave
if ! command -v brave-browser >/dev/null 2>&1; then
    sudo apt -y install apt-transport-https curl
    curl -fsS https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo gpg --dearmor -o /usr/share/keyrings/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt -y install brave-browser
fi

echo "[APPS] Navigateurs installés (Brave + Firefox existant)."
