# ============================
# Oh-My-Zsh Configuration
# ============================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(git zsh-z fzf-tab zsh-autosuggestions)

# ============================
# Spaceship Configuration (MUST be set BEFORE Oh-My-Zsh loads!)
# ============================
# Enable async for performance
SPACESHIP_PROMPT_ASYNC=true

# Keep your original display settings
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_PROMPT_SEPARATE_LINE=true

# Show all the features you want
SPACESHIP_KUBECTL_SHOW=true
SPACESHIP_DOCKER_SHOW=true
SPACESHIP_EXEC_TIME_SHOW=true
SPACESHIP_PACKAGE_SHOW=false  # Can be slow in monorepos
SPACESHIP_NODE_SHOW=false
SPACESHIP_RUBY_SHOW=false
SPACESHIP_PYTHON_SHOW=false
SPACESHIP_AWS_SHOW=true
SPACESHIP_GCLOUD_SHOW=true
SPACESHIP_VENV_SHOW=true
SPACESHIP_CONDA_SHOW=true

# Hide these to reduce clutter
SPACESHIP_HG_SHOW=false
SPACESHIP_AZURE_SHOW=false

# Git status display configuration
SPACESHIP_GIT_STATUS_SHOW=true
SPACESHIP_GIT_STATUS_PREFIX=" ["
SPACESHIP_GIT_STATUS_SUFFIX="]"

# Git status symbols
SPACESHIP_GIT_STATUS_UNTRACKED="?"
SPACESHIP_GIT_STATUS_ADDED="+"
SPACESHIP_GIT_STATUS_MODIFIED="!"
SPACESHIP_GIT_STATUS_RENAMED="»"
SPACESHIP_GIT_STATUS_DELETED="✘"
SPACESHIP_GIT_STATUS_STASHED="$"
SPACESHIP_GIT_STATUS_UNMERGED="="
SPACESHIP_GIT_STATUS_AHEAD="⇡"
SPACESHIP_GIT_STATUS_BEHIND="⇣"
SPACESHIP_GIT_STATUS_DIVERGED="⇕"

# Now load Oh-My-Zsh with all config set
source $ZSH/oh-my-zsh.sh

export PATH=/opt/homebrew/bin:$PATH

# ============================
# Kubernetes Functions and Aliases
# ============================
kwatch () {
    if [ ! -z $1 ]; then
        NAMESPACE="-n $1"
    else
        NAMESPACE=""
    fi
    if [ ! -z $2 ]; then
        POD_SELECTOR="| grep $2"
    else
        POD_SELECTOR=""
    fi
    watch -n5 "kubectl get pods $NAMESPACE $POD_SELECTOR"
}
alias kgp="kubectl get pods"
alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"
source <(kubectl completion zsh)

# ============================
# Environment Variables
# ============================
export LC_ALL=en_US.UTF-8
export PATH=$PATH:$HOME/.bin

# ============================
# NVM (Node Version Manager)
# ============================
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  \. "$NVM_DIR/nvm.sh" # This loads nvm
  
  # Place this after nvm initialization!
  autoload -U add-zsh-hook

  load-nvmrc() {
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version
      nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
        nvm use
      fi
    elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }

  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

# ============================
# Aliases for Editors
# ============================
alias v="nvim"
alias vim="nvim"
alias py="python3"  # Use python3 for py alias

# ============================
# Bat - better cat
# ============================

alias cat="bat"  # Use batcat instead of cat
export BAT_THEME=tokyonight_night

# ============================
# FZF Configuration
# ============================
if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow -E ~/.fdignore'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
# Set up fzf key bindings and fuzzy completion

# ============================
# FZF Preview
# ============================
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# ============================
# Default Editor Configuration
# ============================
export EDTOR="nvim"
export VISUAL="nvim"
export KUBE_EDITOR="nvim"

# ============================
# Go Configuration
# ============================
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# ============================
# Rust Configuration
# ============================
export PATH=$HOME/.cargo/bin:$PATH

# ============================
# Tmuxp Configuration
# ============================
export DISABLE_AUTO_TITLE='true'
export HISTORY_IGNORE="(fg)"

# ============================
# Custom Key Bindings
# ============================
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER=" fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^H' fancy-ctrl-z

# ============================
# Put shell cmd into nvim
# ============================
autoload -U edit-command-line
zle -N edit-command-line 
bindkey -M vicmd v edit-command-line

# FZF integration (if exists)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================
# FZF Tab Plugin
# ============================
if [ -f ~/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.plugin.zsh ]; then
  source ~/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.plugin.zsh
fi

# ============================
# Better LS
# ============================
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

alias dc="docker-compose"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi


export UV_LINK_MODE=copy
export UV_COMPILE_BYTECODE=0
export UV_CACHE_DIR="$HOME/.cache/uv"
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# Private env vars — not committed
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"



