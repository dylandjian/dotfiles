# Dotfiles

My personal dotfiles for my development environment setup.

## Screenshots

![Neovim default](./ss.png)
![Full workflow](./workflow.png)

## Overview

This repository contains configuration files for:

- Neovim (all Lua)
- Tmux
- Zsh (with Oh My Zsh)
- Espanso

## Requirements

### Core Dependencies

- Git
- Neovim >= 0.9.0
- Tmux >= 3.0
- Zsh
- Python >= 3.8
- Rust (latest stable, for stylua)

### Command Line Tools

- fzf (fuzzy finder)
- ripgrep (for file searching)
- fd (modern find replacement)
- bat (cat replacement)
- delta (git diff viewer)
- exa/eza (ls replacement)
- jq (JSON processor)

### Fonts

- A Nerd Font (recommended: Liga SFMono Nerd Font)
- Powerline-compatible font

## Installation

1. Clone into your preferred location:
   ```bash
   git clone https://github.com/dylandjian/dotfiles.git ~/Work/dotfiles
   cd ~/Work/dotfiles
   ```
2. Run the installer — it symlinks configs into place and backs up
   anything it would overwrite to `~/.dotfiles-backup-<timestamp>/`:
   ```bash
   ./install.sh
   ```
3. Private overrides (API keys, work-specific env) go in
   `~/.zshrc.local` — it's sourced at the end of `.zshrc` and gitignored.

### Syncing changes back

If you tweak a config in place (e.g., `~/.config/nvim`) and want to
pull it into the repo, run:

```bash
./sync.sh
```

It replaces the live file with a symlink to the repo copy and
auto-commits the change.

### TODO

- [ ] Make better crossplatform (MacOS / Linux compatibility)
- [ ] Add .gitconfig with delta config and theme

## Credits

- https://github.com/nikolovlazar/dotfiles
- https://github.com/craftzdog/dotfiles-public
- https://github.com/sachinsenal0x64/dotfiles
- https://github.com/typecraft-dev/dotfiles
