#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[sync]${NC} $1"; }
warn() { echo -e "${YELLOW}[sync]${NC} $1"; }
info() { echo -e "${CYAN}[sync]${NC} $1"; }

# Map: dotfiles_relative_path → real_system_path
declare -A LINKS=(
  ["nvim"]="$HOME/.config/nvim"
  ["kitty"]="$HOME/.config/kitty"
  ["tmux/tmux.conf"]="$HOME/.config/tmux/tmux.conf"
  ["espanso"]="$HOME/.config/espanso"
  ["zsh/.zshrc"]="$HOME/.zshrc"
  ["claude/scripts/hourly-worklog.py"]="$HOME/.claude/scripts/hourly-worklog.py"
  ["claude/launchagents/com.claude.hourly-worklog.plist"]="$HOME/Library/LaunchAgents/com.claude.hourly-worklog.plist"
)

synced=0
already_linked=0
skipped=0

for rel in "${!LINKS[@]}"; do
  dest="${LINKS[$rel]}"
  src="$DOTFILES_DIR/$rel"

  # Already a correct symlink → nothing to do
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    info "Already linked: $dest"
    (( already_linked++ )) || true
    continue
  fi

  # System path doesn't exist → nothing to sync
  if [[ ! -e "$dest" ]]; then
    warn "Not found on system, skipping: $dest"
    (( skipped++ )) || true
    continue
  fi

  # Real file/dir exists and isn't symlinked → pull it into the repo
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mkdir -p "$(dirname "$src")"

    if [[ -d "$dest" ]]; then
      cp -r "$dest/" "$src/"
    else
      cp "$dest" "$src"
    fi

    rm -rf "$dest"
    ln -s "$src" "$dest"
    log "Synced + linked: $dest → $src"
    (( synced++ )) || true
    continue
  fi

  # Symlink exists but points somewhere else → warn and skip
  warn "Symlink mismatch (points to $(readlink "$dest")), skipping: $dest"
  (( skipped++ )) || true
done

echo ""
info "Done — $already_linked already linked, $synced synced, $skipped skipped"

# Auto-commit if anything was synced
if [[ $synced -gt 0 ]]; then
  cd "$DOTFILES_DIR"
  git add -A
  git commit -m "chore: sync dotfiles from system ($(date +%Y-%m-%d))"
  log "Committed changes to repo"
fi
