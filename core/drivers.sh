#!/usr/bin/env bash
set -euo pipefail

echo "[CORE] Gestion des drivers..."

# Exemple : ouverture de l'outil de drivers Mint
if command -v ubuntu-drivers >/dev/null 2>&1; then
    echo "Détection des drivers propriétaires recommandés..."
    ubuntu-drivers devices || true
fi

echo "[CORE] Pense à vérifier les drivers via l'outil graphique si nécessaire."
