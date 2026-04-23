#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { echo -e "${GREEN}[dotfiles]${NC} $1"; }
warn()   { echo -e "${YELLOW}[dotfiles]${NC} $1"; }
backup() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -r "$target" "$BACKUP_DIR/"
    warn "Backed up $target → $BACKUP_DIR/"
  fi
}

symlink() {
  local src="$1"
  local dest="$2"

  if [[ ! -e "$src" ]]; then
    warn "Source missing, skipping: $src"
    return
  fi

  backup "$dest"

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    log "Already linked: $dest"
    return
  fi

  rm -rf "$dest"
  ln -s "$src" "$dest"
  log "Linked: $dest → $src"
}

# ── Symlinks ─────────────────────────────────────────────────────────────────
symlink "$DOTFILES_DIR/nvim"              "$HOME/.config/nvim"
symlink "$DOTFILES_DIR/kitty"            "$HOME/.config/kitty"
symlink "$DOTFILES_DIR/tmux/tmux.conf"   "$HOME/.config/tmux/tmux.conf"
symlink "$DOTFILES_DIR/espanso"          "$HOME/.config/espanso"
symlink "$DOTFILES_DIR/zsh/.zshrc"       "$HOME/.zshrc"
symlink "$DOTFILES_DIR/claude/scripts/hourly-worklog.py"                     "$HOME/.claude/scripts/hourly-worklog.py"

log "Done! Reload your shell: source ~/.zshrc"
