#!/usr/bin/env bash
set -euo pipefail

echo "[SECURITY] Durcissement du système..."

# Désactivation de services inutiles (exemples, à adapter)
SERVICES_TO_DISABLE=(
    "avahi-daemon"
    "cups"
)

for svc in "${SERVICES_TO_DISABLE[@]}"; do
    if systemctl is-enabled "$svc" >/dev/null 2>&1; then
        sudo systemctl disable --now "$svc" || true
        echo "Service désactivé : $svc"
    fi
done

echo "[SECURITY] Durcissement basique appliqué."
