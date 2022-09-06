# Path to your oh-my-zsh installation.
export ZSH="/Users/dylandjian/.oh-my-zsh"

ZSH_THEME="spaceship"
plugins=(git zsh-z fzf-tab zsh-autosuggestions)

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
export PATH=$PATH:$HOME/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
export PATH=$PATH:$HOME/.bin


## NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

## Vim
alias v="nvim"
alias vim="nvim"

## Bat
alias cat="bat"

# To apply the command to CTRL-T as well
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow -E ~/.fdignore'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## Default prompt
export EDTOR="/opt/homebrew/bin/nvim"
export VISUAL="/opt/homebrew/bin/nvim"

## Open command line in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xx' edit-command-line
export KUBE_EDITOR="/opt/homebrew/bin/nvim"

## Go
export GOPATH=/Users/$USER/go
export PATH=$GOPATH/bin:$PATH

## Tmuxp
export DISABLE_AUTO_TITLE='true'
export HISTORY_IGNORE="(fg)"

## Use same keybind to suspend and open vim
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

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit prompt spaceship

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export SPACESHIP_KUBECTL_SHOW=true
source ~/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.plugin.zsh
