#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="$ROOT_DIR/config.yml"

declare -A CONFIG

# ------------------------------------------------------------
#  Fonction : parser YAML simple (clé:valeur)
# ------------------------------------------------------------
parse_yaml() {
    local prefix=$2
    local s
    s='[[:space:]]*'
    local w
    w='[a-zA-Z0-9_.-]*'

    sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$prefix\2=\"\3\"|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$prefix\2=\"\3\"|p" "$1"
}

# ------------------------------------------------------------
#  Fonction : charger config.yml dans un tableau associatif
# ------------------------------------------------------------
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "Aucun fichier config.yml trouvé."
        return 1
    fi

    while IFS='=' read -r key value; do
        key=$(echo "$key" | tr '.' '_')
        CONFIG["$key"]="$value"
    done < <(parse_yaml "$CONFIG_FILE" "cfg_")
}

# ------------------------------------------------------------
#  Fonction : récupérer une valeur
# ------------------------------------------------------------
get_config() {
    local key="$1"
    echo "${CONFIG[$key]:-}"
}

# ------------------------------------------------------------
#  Fonction : tester si un module est activé
# ------------------------------------------------------------
is_enabled() {
    local key="$1"
    local val
    val=$(get_config "$key")

    [[ "$val" == "true" ]]
}

# ------------------------------------------------------------
#  Chargement automatique
# ------------------------------------------------------------
load_config
