#!/usr/bin/env bash
set -euo pipefail

# ============================================================
#  Mint Post-Install – Script principal (version avancée+)
# ============================================================

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------------------
#  Variables globales
# ------------------------------------------------------------
AUTO_MODE=false
DEBUG=false
DRY_RUN=false
FORCE=false
TUI=false
PROFILE_NAME="default"
CONFIG_FILE="$ROOT_DIR/config.yml"

CORE_DIR="$ROOT_DIR/core"
SECURITY_DIR="$ROOT_DIR/security"
APPS_DIR="$ROOT_DIR/apps"
NETWORK_DIR="$ROOT_DIR/network"
HOOKS_DIR="$ROOT_DIR/hooks"
PLUGINS_DIR="$ROOT_DIR/plugins"
PROFILES_DIR="$ROOT_DIR/profiles"

# ------------------------------------------------------------
#  Chargement des utilitaires
#  (config-loader doit utiliser $CONFIG_FILE si possible)
# ------------------------------------------------------------
source "$ROOT_DIR/utils/colors.sh"
source "$ROOT_DIR/utils/logging.sh"
source "$ROOT_DIR/utils/checks.sh"

# On exporte CONFIG_FILE pour que config-loader puisse l’utiliser
export CONFIG_FILE
source "$ROOT_DIR/utils/config-loader.sh"

# ------------------------------------------------------------
#  Gestionnaire d’erreurs global
# ------------------------------------------------------------
on_error() {
    local exit_code=$?
    local line_no=${BASH_LINENO[0]:-?}
    log_error "Erreur à la ligne $line_no (code $exit_code)."
    exit "$exit_code"
}
trap on_error ERR

# ------------------------------------------------------------
#  Plugins (chargés avant tout)
# ------------------------------------------------------------
load_plugins() {
    if [[ -d "$PLUGINS_DIR" ]]; then
        for plugin in "$PLUGINS_DIR"/*.sh; do
            [[ -e "$plugin" ]] || continue
            log_info "Chargement du plugin: $(basename "$plugin")"
            source "$plugin"
        done
    fi
}

# ------------------------------------------------------------
#  Hooks
# ------------------------------------------------------------
run_hook() {
    local hook_name="$1"
    local hook_script="$HOOKS_DIR/$hook_name.sh"

    if [[ -x "$hook_script" ]]; then
        log_info "Exécution du hook: $hook_name"
        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY-RUN] $hook_script"
        else
            bash "$hook_script"
        fi
    fi
}

# ------------------------------------------------------------
#  Utilitaires avancés
# ------------------------------------------------------------
run_cmd() {
    local cmd="$*"
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${RESET} $cmd"
        log_info "[DRY-RUN] $cmd"
    else
        debug "CMD: $cmd"
        eval "$cmd"
    fi
}

debug() {
    if [[ "$DEBUG" == true ]]; then
        echo -e "${YELLOW}[DEBUG]${RESET} $*"
    fi
}

usage() {
    echo -e "${BOLD}Usage:${RESET} ./install.sh [options]"
    echo
    echo "Options :"
    echo "  --auto             Mode automatique (config.yml / profil)"
    echo "  --profile NAME     Utiliser profiles/NAME.yml"
    echo "  --debug            Active le mode debug"
    echo "  --dry-run          Affiche les actions sans les exécuter"
    echo "  --force            Ignore certaines confirmations"
    echo "  --tui              Mode TUI (menu en ncurses via whiptail/dialog)"
    echo "  --help             Affiche cette aide"
    exit 0
}

# ------------------------------------------------------------
#  Analyse des arguments CLI
# ------------------------------------------------------------
for arg in "$@"; do
    case "$arg" in
        --auto) AUTO_MODE=true ;;
        --debug) DEBUG=true ;;
        --dry-run) DRY_RUN=true ;;
        --force) FORCE=true ;;
        --tui) TUI=true ;;
        --profile)
            echo "L’option --profile doit être suivie d’un nom (ex: --profile dev)"
            exit 1
            ;;
        --profile=*)
            PROFILE_NAME="${arg#*=}"
            ;;
        --help) usage ;;
        *) echo "Option inconnue : $arg"; usage ;;
    esac
done

# Profil : si profiles/NAME.yml existe, on l’utilise comme config
if [[ -d "$PROFILES_DIR" ]] && [[ -f "$PROFILES_DIR/$PROFILE_NAME.yml" ]]; then
    CONFIG_FILE="$PROFILES_DIR/$PROFILE_NAME.yml"
    export CONFIG_FILE
    log_info "Profil utilisé: $PROFILE_NAME ($CONFIG_FILE)"
    # Recharger la config avec le bon fichier
    load_config
elif [[ -f "$ROOT_DIR/config.yml" ]]; then
    CONFIG_FILE="$ROOT_DIR/config.yml"
    export CONFIG_FILE
    AUTO_MODE=true
    log_info "Fichier config.yml détecté (mode auto activé)."
fi

# ------------------------------------------------------------
#  Vérifications système
# ------------------------------------------------------------
check_root
check_distro
detect_hardware

# Chargement des plugins
load_plugins

# ============================================================
#  Fonctions d’exécution des sous-modules
# ============================================================

run_core_system()   { run_cmd bash "$CORE_DIR/system.sh"; }
run_core_updates()  { run_cmd bash "$CORE_DIR/updates.sh"; }
run_core_drivers()  { run_cmd bash "$CORE_DIR/drivers.sh"; }
run_core_cleanup()  { run_cmd bash "$CORE_DIR/cleanup.sh"; }

run_security_firewall()  { run_cmd bash "$SECURITY_DIR/firewall.sh"; }
run_security_hardening() { run_cmd bash "$SECURITY_DIR/hardening.sh"; }
run_security_apparmor()  { run_cmd bash "$SECURITY_DIR/apparmor.sh"; }
run_security_audit()     { run_cmd bash "$SECURITY_DIR/audit.sh"; }

run_apps_dev()        { run_cmd bash "$APPS_DIR/dev-tools.sh"; }
run_apps_multimedia() { run_cmd bash "$APPS_DIR/multimedia.sh"; }
run_apps_office()     { run_cmd bash "$APPS_DIR/office.sh"; }
run_apps_browsers()   { run_cmd bash "$APPS_DIR/browsers.sh"; }

run_network_dns()   { run_cmd bash "$NETWORK_DIR/dns.sh"; }
run_network_vpn()   { run_cmd bash "$NETWORK_DIR/vpn.sh"; }
run_network_wifi()  { run_cmd bash "$NETWORK_DIR/wifi.sh"; }

# ============================================================
#  Fonctions d’exécution des modules complets
# ============================================================

run_core() {
    log_section "Core"
    run_hook "pre_core"
    run_core_system
    run_core_updates
    run_core_drivers
    run_core_cleanup
    run_hook "post_core"
}

run_security() {
    log_section "Sécurité"
    run_hook "pre_security"
    run_security_firewall
    run_security_hardening
    run_security_apparmor
    run_security_audit
    run_hook "post_security"
}

run_apps() {
    log_section "Applications"
    run_hook "pre_apps"
    run_apps_dev
    run_apps_multimedia
    run_apps_office
    run_apps_browsers
    run_hook "post_apps"
}

run_network() {
    log_section "Réseau"
    run_hook "pre_network"
    run_network_dns
    run_network_vpn
    run_network_wifi
    run_hook "post_network"
}

run_all() {
    run_core
    run_security
    run_apps
    run_network
}

# ============================================================
#  Mode automatique (avec sous-modules)
# ============================================================

run_automatic_mode() {
    log_section "Mode automatique activé"

    # Core
    if is_enabled "modules_core_enabled"; then
        if is_enabled "modules_core_system";   then run_core_system;   fi
        if is_enabled "modules_core_updates";  then run_core_updates;  fi
        if is_enabled "modules_core_drivers";  then run_core_drivers;  fi
        if is_enabled "modules_core_cleanup";  then run_core_cleanup;  fi
    fi

    # Sécurité
    if is_enabled "modules_security_enabled"; then
        if is_enabled "modules_security_firewall";  then run_security_firewall;  fi
        if is_enabled "modules_security_hardening"; then run_security_hardening; fi
        if is_enabled "modules_security_apparmor";  then run_security_apparmor;  fi
        if is_enabled "modules_security_audit";     then run_security_audit;     fi
    fi

    # Applications
    if is_enabled "modules_apps_enabled"; then
        if is_enabled "modules_apps_dev_tools";   then run_apps_dev;        fi
        if is_enabled "modules_apps_multimedia";  then run_apps_multimedia; fi
        if is_enabled "modules_apps_office";      then run_apps_office;     fi
        if is_enabled "modules_apps_browsers";    then run_apps_browsers;   fi
    fi

    # Réseau
    if is_enabled "modules_network_enabled"; then
        if is_enabled "modules_network_dns";   then run_network_dns;   fi
        if is_enabled "modules_network_vpn";   then run_network_vpn;   fi
        if is_enabled "modules_network_wifi";  then run_network_wifi;  fi
    fi

    log_info "Mode automatique terminé."
}

# ============================================================
#  Menu TUI (whiptail/dialog)
# ============================================================

show_tui_menu() {
    local cmd
    if command -v whiptail >/dev/null 2>&1; then
        cmd="whiptail"
    elif command -v dialog >/dev/null 2>&1; then
        cmd="dialog"
    else
        log_warn "Aucun outil TUI (whiptail/dialog) trouvé, retour au menu texte."
        show_main_menu
        return
    fi

    while true; do
        local choice
        choice=$($cmd --clear --title "Mint Post-Install" \
            --menu "Sélectionne une action" 20 70 10 \
            1 "Core" \
            2 "Sécurité" \
            3 "Applications" \
            4 "Réseau" \
            5 "Tout exécuter" \
            0 "Quitter" \
            3>&1 1>&2 2>&3) || { log_info "Sortie."; break; }

        case "$choice" in
            1) run_core ;;
            2) run_security ;;
            3) run_apps ;;
            4) run_network ;;
            5) run_all ;;
            0) log_info "Sortie."; break ;;
        esac
    done
}

# ============================================================
#  Menu interactif texte
# ============================================================

show_main_menu() {
    while true; do
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
            *) log_error "Choix invalide." ;;
        esac
    done
}

# ============================================================
#  Exécution finale
# ============================================================

if [[ "$AUTO_MODE" == true ]]; then
    run_automatic_mode
else
    if [[ "$TUI" == true ]]; then
        show_tui_menu
    else
        show_main_menu
    fi
fi
