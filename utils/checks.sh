#!/usr/bin/env bash

check_root() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "Ce script doit être exécuté en root (sudo)." >&2
        exit 1
    fi
}

check_distro() {
    if ! grep -qi "linux mint" /etc/os-release; then
        echo "Attention: ce script est prévu pour Linux Mint." >&2
    fi
}

detect_hardware() {
    echo "Détection matérielle rapide :"
    echo "- CPU : $(lscpu | grep 'Model name' | sed 's/Model name:\s*//')"
    echo "- RAM : $(free -h | awk '/Mem:/ {print $2}')"
    if command -v lspci >/dev/null 2>&1; then
        echo "- GPU :"
        lspci | grep -Ei 'vga|3d|display' || true
    fi
    echo
}
