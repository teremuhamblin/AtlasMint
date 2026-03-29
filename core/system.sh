#!/usr/bin/env bash
set -euo pipefail

echo "[CORE] Configuration de base du système..."

# Exemple : réglages sysctl de protection
SYSCTL_CONF="/etc/sysctl.d/99-mint-hardening.conf"

cat <<EOF >/tmp/mint-hardening.conf
kernel.kptr_restrict = 2
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
kernel.yama.ptrace_scope = 1
EOF

sudo mv /tmp/mint-hardening.conf "$SYSCTL_CONF"
sudo sysctl --system

echo "[CORE] Paramètres sysctl de durcissement appliqués."
