# Path to your oh-my-zsh installation.
export ZSH="~/.oh-my-zsh"

## ZSH config
ZSH_THEME="spaceship"
plugins=(git zsh-z zsh-autosuggestions fzf-zsh)
source $ZSH/oh-my-zsh.sh

## Kubernetes stuff
kwatch () {
    if [ ! -z $1 ]
    then
            NAMESPACE="-n $1"
    else
            NAMESPACE=""
    fi
    if [ ! -z $2 ]
    then
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

## Random
export LC_ALL=en_US.UTF-8

## NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Vim
alias v="nvim"
alias vim="nvim"

# To apply the command to CTRL-T as well
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow -E ~/.fdignore'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## Use Vim for command line prompt
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line
