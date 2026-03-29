#!/usr/bin/env bash
set -euo pipefail

echo "[NETWORK] Configuration DNS sécurisés..."

RESOLV_CONF="/etc/systemd/resolved.conf"

sudo sed -i 's/^#DNS=.*/DNS=9.9.9.9 1.1.1.2/' "$RESOLV_CONF" || true
sudo sed -i 's/^#FallbackDNS=.*/FallbackDNS=149.112.112.112 1.0.0.2/' "$RESOLV_CONF" || true

sudo systemctl restart systemd-resolved || true

echo "[NETWORK] DNS configurés (Quad9 + Cloudflare Security)."
