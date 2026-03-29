#!/usr/bin/env bash
set -euo pipefail

echo "[APPS] Installation des outils multimédia..."

sudo apt -y install \
    vlc \
    obs-studio \
    kdenlive \
    ffmpeg

echo "[APPS] Outils multimédia installés."
