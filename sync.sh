#!/bin/bash
# Sync Neovim config between Aevox.nvim repo and AppData/Local/nvim
# Usage:
#   ./sync.sh push   - AppData → Aevox.nvim (default, for committing)
#   ./sync.sh pull   - Aevox.nvim → AppData  (after pulling from remote)

REPO="D:/Projects/LazyVimPlugs/Aevox.nvim"
NVIM="C:/Users/Win11/AppData/Local/nvim"
EXCLUDE=(.git .claude sync.sh)

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

case "${1:-push}" in
  push)
    echo "Syncing: AppData/nvim -> Aevox.nvim"
    sync_dir "$NVIM" "$REPO"
    echo "Done. Run 'git add/commit/push' in Aevox.nvim."
    ;;
  pull)
    echo "Syncing: Aevox.nvim -> AppData/nvim"
    sync_dir "$REPO" "$NVIM"
    echo "Done. Neovim config updated."
    ;;
  *)
    echo "Usage: sync.sh [push|pull]"
    echo "  push  AppData/nvim -> Aevox.nvim (default)"
    echo "  pull  Aevox.nvim -> AppData/nvim"
    ;;
esac
