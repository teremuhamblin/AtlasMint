#!/usr/bin/env bash
set -euo pipefail

echo "[NETWORK] Vérification du Wi-Fi..."

if command -v nmcli >/dev/null 2>&1; then
    nmcli device status
    echo
    echo "Utilise 'nmcli device wifi list' pour voir les réseaux disponibles."
else
    echo "NetworkManager (nmcli) non disponible."
fi
