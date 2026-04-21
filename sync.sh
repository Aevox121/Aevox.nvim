#!/bin/bash
# Sync Neovim config between Aevox.nvim repo and AppData/Local/nvim
# Usage:
#   ./sync.sh push   - AppData → Aevox.nvim (default, for committing)
#   ./sync.sh pull   - Aevox.nvim → AppData  (after pulling from remote)

REPO="D:/Projects/Work/Dev/LazyVimPlugs/Aevox.nvim"
NVIM="C:/Users/Win11/AppData/Local/nvim"
EXCLUDE=(.git .claude .gitignore sync.sh)

# Paths (relative to nvim root) that are local-only: live in AppData only,
# never in the published repo. Used for machine-specific overrides like
# `lua/config/lazy-local.lua` (dev plugin paths).
LOCAL_ONLY=(lua/config/lazy-local.lua)

should_exclude() {
  local name="$1"
  for ex in "${EXCLUDE[@]}"; do
    [[ "$name" == "$ex" ]] && return 0
  done
  return 1
}

sync_dir() {
  local src="$1" dst="$2"

  # Remove old entries in dst (except excluded)
  for item in "$dst"/* "$dst"/.*; do
    local base
    base=$(basename "$item")
    [[ "$base" == "." || "$base" == ".." ]] && continue
    should_exclude "$base" && continue
    rm -rf "$item"
  done

  # Copy from src (except excluded)
  for item in "$src"/* "$src"/.*; do
    local base
    base=$(basename "$item")
    [[ "$base" == "." || "$base" == ".." ]] && continue
    should_exclude "$base" && continue
    cp -r "$item" "$dst/"
  done
}

backup_local_only() {
  BACKUP_DIR=$(mktemp -d)
  for rel in "${LOCAL_ONLY[@]}"; do
    if [ -f "$NVIM/$rel" ]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      cp "$NVIM/$rel" "$BACKUP_DIR/$rel"
    fi
  done
}

restore_local_only() {
  for rel in "${LOCAL_ONLY[@]}"; do
    if [ -f "$BACKUP_DIR/$rel" ]; then
      mkdir -p "$NVIM/$(dirname "$rel")"
      cp "$BACKUP_DIR/$rel" "$NVIM/$rel"
    fi
  done
  rm -rf "$BACKUP_DIR"
}

strip_local_only_from_repo() {
  for rel in "${LOCAL_ONLY[@]}"; do
    rm -f "$REPO/$rel"
  done
}

case "${1:-push}" in
  push)
    echo "Syncing: AppData/nvim -> Aevox.nvim"
    sync_dir "$NVIM" "$REPO"
    strip_local_only_from_repo
    echo "Done. Run 'git add/commit/push' in Aevox.nvim."
    ;;
  pull)
    echo "Syncing: Aevox.nvim -> AppData/nvim"
    backup_local_only
    sync_dir "$REPO" "$NVIM"
    restore_local_only
    echo "Done. Neovim config updated."
    ;;
  *)
    echo "Usage: sync.sh [push|pull]"
    echo "  push  AppData/nvim -> Aevox.nvim (default)"
    echo "  pull  Aevox.nvim -> AppData/nvim"
    ;;
esac
