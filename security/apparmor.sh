#!/usr/bin/env bash
set -euo pipefail

echo "[SECURITY] Configuration d'AppArmor..."

sudo apt -y install apparmor apparmor-utils

sudo systemctl enable --now apparmor

# Exemple : mettre certains profils en mode enforce
if [ -d /etc/apparmor.d ]; then
    sudo aa-enforce /etc/apparmor.d/* || true
fi

echo "[SECURITY] AppArmor activé (enforce si possible)."
