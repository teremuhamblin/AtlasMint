#!/usr/bin/env bash
set -euo pipefail

echo "[CORE] Mise à jour du système..."

sudo apt update
sudo apt -y full-upgrade
sudo apt -y autoremove --purge

echo "[CORE] Mises à jour terminées."
