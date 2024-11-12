# ============================
# Oh-My-Zsh Configuration
# ============================
export ZSH="/home/dylan/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(git zsh-z fzf-tab zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

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
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow -E ~/.fdignore'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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
    *)            fzf --preview "batcat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# ============================
# Default Editor Configuration
# ============================
export EDTOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export KUBE_EDITOR="/usr/bin/nvim"

# ============================
# Go Configuration
# ============================
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

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
# Spaceship ZSH Prompt
# ============================
autoload -U promptinit; promptinit prompt spaceship
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================
# Spaceship Configuration
# ============================
export SPACESHIP_KUBECTL_SHOW=true
export SPACESHIP_PROMPT_ASYNC=false

# ============================
# FZF Tab Plugin
# ============================
source ~/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.plugin.zsh

# ============================
# Better LS
# ============================
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
