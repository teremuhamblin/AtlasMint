#!/usr/bin/env bash
set -euo pipefail

echo "[SECURITY] Configuration du pare-feu UFW..."

sudo apt -y install ufw

sudo ufw default deny incoming
sudo ufw default allow outgoing

# Exemple : autoriser SSH si besoin
# sudo ufw allow ssh

sudo ufw --force enable

echo "[SECURITY] UFW activé avec politique restrictive."
