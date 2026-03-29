#!/usr/bin/env bash

LOG_FILE="/var/log/mint-postinstall.log"

log_init() {
    if [[ ! -f "$LOG_FILE" ]]; then
        sudo touch "$LOG_FILE" 2>/dev/null || true
    fi
}

log() {
    local level="$1"; shift
    local msg="$*"
    local ts
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$ts] [$level] $msg" | tee -a "$LOG_FILE"
}

log_info()    { log "INFO"    "$@"; }
log_warn()    { log "WARN"    "$@"; }
log_error()   { log "ERROR"   "$@"; }
log_section() { log "SECTION" "=== $* ==="; }

log_init
