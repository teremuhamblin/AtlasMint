#!/usr/bin/env bash
set -euo pipefail

echo "[CORE] Nettoyage du système..."

sudo apt -y autoremove --purge
sudo apt -y autoclean
sudo journalctl --vacuum-time=7d || true

echo "[CORE] Nettoyage terminé."
