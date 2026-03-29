#!/usr/bin/env bash
set -euo pipefail

# ============================================================
#  Mint Post-Install – Script principal
# ============================================================

# 1. Détection de la racine du projet
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 2. Chargement des utilitaires
source "$ROOT_DIR/utils/colors.sh"
source "$ROOT_DIR/utils/logging.sh"
source "$ROOT_DIR/utils/checks.sh"
source "$ROOT_DIR/utils/config-loader.sh"

# 3. Détection du mode automatique
if [[ -f "$ROOT_DIR/config.yml" ]]; then
    AUTO_MODE=true
else
    AUTO_MODE=false
fi

# 4. Vérifications système
check_root
check_distro
detect_hardware

# 5. Définition des chemins des modules
CORE_DIR="$ROOT_DIR/core"
SECURITY_DIR="$ROOT_DIR/security"
APPS_DIR="$ROOT_DIR/apps"
NETWORK_DIR="$ROOT_DIR/network"

# ============================================================
#  Fonctions d’exécution des modules
# ============================================================

run_core() {
    log_section "Core"
    bash "$CORE_DIR/system.sh"
    bash "$CORE_DIR/updates.sh"
    bash "$CORE_DIR/drivers.sh"
    bash "$CORE_DIR/cleanup.sh"
}

run_security() {
    log_section "Sécurité"
    bash "$SECURITY_DIR/firewall.sh"
    bash "$SECURITY_DIR/hardening.sh"
    bash "$SECURITY_DIR/apparmor.sh"
    bash "$SECURITY_DIR/audit.sh"
}

run_apps() {
    log_section "Applications"
    bash "$APPS_DIR/dev-tools.sh"
    bash "$APPS_DIR/multimedia.sh"
    bash "$APPS_DIR/office.sh"
    bash "$APPS_DIR/browsers.sh"
}

run_network() {
    log_section "Réseau"
    bash "$NETWORK_DIR/dns.sh"
    bash "$NETWORK_DIR/vpn.sh"
    bash "$NETWORK_DIR/wifi.sh"
}

run_all() {
    run_core
    run_security
    run_apps
    run_network
}

# ============================================================
#  Mode automatique (lecture de config.yml)
# ============================================================

run_automatic_mode() {
    log_section "Mode automatique activé (config.yml détecté)"

    # Modules principaux
    if is_enabled "modules_core_enabled"; then
        run_core
    fi

    if is_enabled "modules_security_enabled"; then
        run_security
    fi

    if is_enabled "modules_apps_enabled"; then
        run_apps
    fi

    if is_enabled "modules_network_enabled"; then
        run_network
    fi

    log_info "Mode automatique terminé."
}

# ============================================================
#  Menu interactif
# ============================================================

show_main_menu() {
    echo -e "${BOLD}${CYAN}=== Mint Post-Install ===${RESET}"
    echo "1) Core (système, mises à jour, drivers, cleanup)"
    echo "2) Sécurité (firewall, hardening, AppArmor, audit)"
    echo "3) Applications (dev, multimédia, office, navigateurs)"
    echo "4) Réseau (DNS, VPN, Wi-Fi)"
    echo "5) Tout exécuter"
    echo "0) Quitter"
    echo
    read -rp "Choix: " choice

    case "$choice" in
        1) run_core ;;
        2) run_security ;;
        3) run_apps ;;
        4) run_network ;;
        5) run_all ;;
        0) log_info "Sortie."; exit 0 ;;
        *) log_error "Choix invalide."; show_main_menu ;;
    esac
}

# ============================================================
#  Exécution finale
# ============================================================

if [[ "$AUTO_MODE" == true ]]; then
    run_automatic_mode
else
    show_main_menu
fi
