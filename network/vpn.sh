#!/usr/bin/env bash
set -euo pipefail

echo "[NETWORK] Installation de WireGuard (VPN recommandé)..."

sudo apt -y install wireguard

echo "[NETWORK] WireGuard installé."
echo "Tu peux maintenant ajouter ta configuration dans /etc/wireguard/wg0.conf"
