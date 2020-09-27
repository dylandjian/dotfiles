# Path to your oh-my-zsh installation.
export ZSH="/Users/dylandjian/.oh-my-zsh"

ZSH_THEME="spaceship"
plugins=(git zsh-z zsh-autosuggestions fzf-zsh fzf-tab)

source $ZSH/oh-my-zsh.sh
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh

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
export PATH=$PATH:$HOME/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
export PATH=$PATH:$HOME/.bin


## NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Vim
alias v="nvim"
alias vim="nvim"

## Bat
alias cat="bat"

# To apply the command to CTRL-T as well
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow -E ~/.fdignore'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## Default prompt
export EDTOR="/usr/local/bin/nvim"
export VISUAL="/usr/local/bin/nvim"

## Open command line in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xx' edit-command-line

## Go
export GOPATH=/Users/$USER/go
export PATH=$GOPATH/bin:$PATH
