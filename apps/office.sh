#!/usr/bin/env bash
set -euo pipefail

echo "[APPS] Installation des outils bureautiques..."

sudo apt -y install \
    libreoffice \
    libreoffice-l10n-fr \
    hunspell-fr

echo "[APPS] Suite bureautique installée."
