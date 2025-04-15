#!/usr/bin/env bash

# === COLORS ===
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RESET="\033[0m"

# === CONFIG ===
WORKDIR="../"
CLANG_CITS_SOURCE="../src/clangdcits.wat"
BUILD_DIR="../build"
CARGO_PKG="../"
LOG_FILE="./build.log"
DRY_RUN=false

log() {
  echo -e "${CYAN}[LOG]${RESET} $1" | tee -a "$LOG_FILE"
}

error() {
  echo -e "${RED}[ERROR]${RESET} $1" | tee -a "$LOG_FILE"
}

success() {
  echo -e "${GREEN}[OK]${RESET} $1" | tee -a "$LOG_FILE"
}

build_clangdcits() {
  log "Checking for wasmer..."
  if ! command -v wasmer >/dev/null 2>&1; then
    error "wasmer not found. Install wasmer first."
    exit 1
  fi

  log "Building $CLANG_CITS_SOURCE"
  $DRY_RUN || wasmer compile "$CLANG_CITS_SOURCE" -o ./build/clangd.wasm | tee -a "$LOG_FILE"
  success "Build complete!"
}

# === ARG PARSE ===
case "$1" in
dry-run)
  DRY_RUN=true
  log "Dry-run enabled. No commands will be executed."
  ;;
build)
  build_clangdcits
  ;;
*)
  echo -e "${YELLOW}Usage:${RESET} ./build.sh [build|dry-run]"
  ;;
esac
