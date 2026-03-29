#!/usr/bin/env bash
set -euo pipefail

echo "[APPS] Installation des outils développeur..."

sudo apt -y install \
    build-essential \
    git \
    curl \
    wget \
    python3 python3-pip \
    nodejs npm \
    docker.io docker-compose \
    podman

echo "[APPS] Outils développeur installés."
