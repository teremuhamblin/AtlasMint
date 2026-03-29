#!/usr/bin/env bash
set -euo pipefail

echo "[SECURITY] Audit de sécurité initial..."

sudo apt -y install lynis

sudo lynis audit system || true

echo "[SECURITY] Audit terminé. Consulte /var/log/lynis.log pour les détails."
