#!/usr/bin/env bash

# === COLORS ===
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RESET="\033[0m"

# === CONFIG ===
REPO_URL="https://github.com/yourname/cit.git"
BUILD_SCRIPT="./build.sh"
LOG_FILE="./install.log"
DRY_RUN=false

# === HELPERS ===
log() { echo -e "${CYAN}[INFO]${RESET} $1" | tee -a "$LOG_FILE"; }
success() { echo -e "${GREEN}[OK]${RESET} $1" | tee -a "$LOG_FILE"; }
warn() { echo -e "${YELLOW}[WARN]${RESET} $1" | tee -a "$LOG_FILE"; }
error() { echo -e "${RED}[ERROR]${RESET} $1" | tee -a "$LOG_FILE"; }

run() {
  if $DRY_RUN; then
    log "DRY-RUN: $*"
  else
    eval "$@"
  fi
}

# === BANNER ===
echo -e "${CYAN}"
echo "   ______ _ _        "
echo "  / ____(_) |       "
echo " | |     _| |_  "
echo " | |    | | __/ "
echo " | |____| | |"
echo "  \_____|_|\__\  "
echo "  Cit Installer   "
echo -e "${RESET}"

# === PARSE FLAGS ===
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  log "Dry-run mode enabled"
fi

# === CHECK FOR build.sh ===
if [[ ! -f "$BUILD_SCRIPT" ]]; then
  warn "No build.sh found, attempting to clone Cit from GitHub..."
  run "git clone $REPO_URL cit-temp"
  cd cit-temp || exit 1
  success "Cloned repository into cit-temp"
fi

# === CHOOSE ENV ===
if command -v nix-shell >/dev/null 2>&1; then
  success "nix-shell found, using Nix environment"
  run "nix-shell --run './scripts/build.sh build'"
elif command -v docker-compose >/dev/null 2>&1; then
  success "docker-compose found, using Docker"
  run "docker-compose up -d"
  run "docker-compose exec -- /bin/sh ./scripts/build.sh build"
else
  warn "Neither nix-shell nor docker-compose found, doing raw build"
  run "bash ./scripts/build.sh build"
fi

success "Cit installation finished!"
