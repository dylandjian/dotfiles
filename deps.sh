#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[deps]${NC} $1"; }
warn() { echo -e "${YELLOW}[deps]${NC} $1"; }
err()  { echo -e "${RED}[deps]${NC} $1" >&2; }

# ── OS detection ─────────────────────────────────────────────────────────────
case "$(uname)" in
  Darwin) OS=macos ;;
  Linux)  OS=linux ;;
  *) err "Unsupported OS: $(uname)"; exit 1 ;;
esac

if [[ "$OS" == "linux" ]] && ! command -v apt-get &>/dev/null; then
  err "Linux support currently requires apt (Debian/Ubuntu/Raspbian)."
  err "PRs welcome for dnf/pacman/etc."
  exit 1
fi

is_macos() { [[ "$OS" == macos ]]; }
is_linux() { [[ "$OS" == linux ]]; }

log "Detected OS: $OS"

# ── Homebrew (macOS only) ────────────────────────────────────────────────────
if is_macos && ! command -v brew &>/dev/null; then
  log "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif is_macos; then
  log "Homebrew already installed"
fi

# ── Core CLI tools ───────────────────────────────────────────────────────────
if is_macos; then
  log "Installing CLI tools via brew…"
  brew install \
    git neovim tmux zsh python \
    fzf ripgrep fd bat git-delta eza jq \
    kubectl kubectx rbenv libpq

  [[ -f "$HOME/.fzf.zsh" ]] || \
    "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc
else
  log "Installing CLI tools via apt…"
  sudo apt-get update
  sudo apt-get install -y \
    git neovim tmux zsh python3 python3-pip \
    build-essential curl pkg-config libssl-dev \
    ripgrep fd-find bat jq \
    rbenv libpq-dev

  # Debian ships `fd-find` (binary: fdfind) and sometimes `batcat` — shim
  # them to the names the .zshrc expects.
  mkdir -p "$HOME/.local/bin"
  if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    log "Shimmed fdfind → ~/.local/bin/fd"
  fi
  if ! command -v bat &>/dev/null && command -v batcat &>/dev/null; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
    log "Shimmed batcat → ~/.local/bin/bat"
  fi

  # git-delta, kubectl, kubectx aren't in default Debian/Ubuntu apt repos
  # — install straight from GitHub / dl.k8s.io (no third-party apt repos).
  ARCH=$(dpkg --print-architecture)  # amd64 | arm64 | armhf

  if ! command -v delta &>/dev/null; then
    DELTA_VERSION=0.18.2
    log "Installing git-delta $DELTA_VERSION…"
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/delta.deb" \
      "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCH}.deb"
    sudo dpkg -i "$tmp/delta.deb" || sudo apt-get install -f -y
    rm -rf "$tmp"
  else
    log "git-delta already installed"
  fi

  if ! command -v kubectl &>/dev/null; then
    log "Installing kubectl (latest stable)…"
    KUBE_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
    KUBE_ARCH=$ARCH
    [[ "$KUBE_ARCH" == "armhf" ]] && KUBE_ARCH=arm
    curl -fsSL -o /tmp/kubectl \
      "https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/${KUBE_ARCH}/kubectl"
    sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
    rm -f /tmp/kubectl
  else
    log "kubectl already installed"
  fi

  if ! command -v kubectx &>/dev/null; then
    KCTX_VERSION=0.9.5
    log "Installing kubectx/kubens $KCTX_VERSION…"
    case "$ARCH" in
      amd64) KCTX_ARCH=x86_64 ;;
      arm64) KCTX_ARCH=arm64 ;;
      armhf) KCTX_ARCH=armv7 ;;
      *)     KCTX_ARCH=$ARCH ;;
    esac
    tmp=$(mktemp -d)
    for bin in kubectx kubens; do
      curl -fsSL -o "$tmp/$bin.tar.gz" \
        "https://github.com/ahmetb/kubectx/releases/download/v${KCTX_VERSION}/${bin}_v${KCTX_VERSION}_linux_${KCTX_ARCH}.tar.gz"
      tar -xzf "$tmp/$bin.tar.gz" -C "$tmp"
      sudo install -m 0755 "$tmp/$bin" "/usr/local/bin/$bin"
    done
    rm -rf "$tmp"
  else
    log "kubectx already installed"
  fi

  # fzf from git — apt's version on older distros predates `fzf --zsh`
  # which the .zshrc sources.
  if [[ ! -d "$HOME/.fzf" ]]; then
    log "Installing fzf from git…"
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
  else
    log "fzf already installed"
  fi
fi

# ── GUI apps + fonts (macOS only) ────────────────────────────────────────────
if is_macos; then
  log "Installing casks (kitty, espanso, Nerd Font)…"
  brew install --cask kitty espanso font-sf-mono-nerd-font
else
  warn "Skipping kitty / espanso / Nerd Font — install manually on Linux"
fi

# ── Oh My Zsh ────────────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing Oh My Zsh…"
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "Oh My Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_plugin() {
  local repo="$1" dest="$2"
  if [[ -d "$dest" ]]; then
    log "Plugin already present: $(basename "$dest")"
  else
    git clone --depth=1 "$repo" "$dest"
    log "Installed plugin: $(basename "$dest")"
  fi
}

clone_plugin https://github.com/spaceship-prompt/spaceship-prompt.git \
  "$ZSH_CUSTOM/themes/spaceship-prompt"
[[ -L "$ZSH_CUSTOM/themes/spaceship.zsh-theme" ]] || \
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" \
        "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

clone_plugin https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_plugin https://github.com/Aloxaf/fzf-tab \
  "$ZSH_CUSTOM/plugins/fzf-tab"
clone_plugin https://github.com/agkozak/zsh-z \
  "$ZSH_CUSTOM/plugins/zsh-z"

# ── nvm + Node LTS (node is nvm-managed, not system-managed) ─────────────────
# The .zshrc sets NVM_DIR to $XDG_CONFIG_HOME/nvm when that's defined,
# else $HOME/.nvm — honour the same logic so install path matches the
# shell's expectations. mkdir -p the target first so the installer's
# "NVM_DIR set but doesn't exist" bail-out doesn't trigger.
NVM_TARGET="${NVM_DIR:-${XDG_CONFIG_HOME:+$XDG_CONFIG_HOME/nvm}}"
NVM_TARGET="${NVM_TARGET:-$HOME/.nvm}"

if [[ ! -s "$NVM_TARGET/nvm.sh" ]]; then
  log "Installing nvm to $NVM_TARGET…"
  mkdir -p "$NVM_TARGET"
  NVM_DIR="$NVM_TARGET" PROFILE=/dev/null bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh)"
else
  log "nvm already installed at $NVM_TARGET"
fi
export NVM_DIR="$NVM_TARGET"
# shellcheck disable=SC1091
\. "$NVM_DIR/nvm.sh"

if ! nvm ls --no-colors | grep -q 'lts'; then
  log "Installing Node LTS via nvm…"
  nvm install --lts
  nvm alias default 'lts/*'
else
  log "Node LTS already installed"
fi

# ── Rust + stylua (nvim Lua formatter) ───────────────────────────────────────
if ! command -v rustup &>/dev/null; then
  log "Installing Rust via rustup…"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
else
  log "Rust already installed"
fi

if ! command -v stylua &>/dev/null; then
  log "Installing stylua via cargo…"
  cargo install stylua
else
  log "stylua already installed"
fi

# ── eza on Linux (mac got it via brew above) ─────────────────────────────────
if is_linux && ! command -v eza &>/dev/null; then
  log "Installing eza via cargo (this is slow on ARM — one-time)…"
  cargo install eza
elif is_linux; then
  log "eza already installed"
fi

# ── uv (Python package/runtime manager) ──────────────────────────────────────
if ! command -v uv &>/dev/null; then
  log "Installing uv…"
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  log "uv already installed"
fi

# ── Node-based nvim tooling ──────────────────────────────────────────────────
if command -v npm &>/dev/null; then
  log "Installing prettier + eslint_d globally…"
  npm install -g prettier eslint_d
else
  warn "npm not found — skipping prettier/eslint_d (re-run this script after nvm init)"
fi

log "Done! Next: ./install.sh to symlink configs, then exec zsh"
