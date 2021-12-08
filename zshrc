# for XWin ...

# === get all apps and create an aliases for them

# === for normal aliases
if [[ -r ~/.zsh/aliases ]]; then
    source ~/.zsh/aliases
fi

# === zsh shell functions
if [[ -r ~/.zsh/my_func.zsh ]]; then
    source ~/.zsh/my_func.zsh
fi

# === cd names as commands  --- very handy
if [[ -r ~/.zsh/cdnames ]]; then
    source ~/.zsh/cdnames
fi

# === key bindings
if [[ -r ~/.zsh/bindingkeys ]]; then
    source ~/.zsh/bindingkeys
fi

# === zsh completion styles
if [[ -r ~/.zsh/zsh_comp_styles ]]; then
    source ~/.zsh/comp_styles
fi

# initialize docker
if [[ $(which docker-machine) == 0 ]]; then
	eval $(docker-machine env)
fi

# === third party shell libraries
if [[ -r ~/lib/shell/zsh/my_shell_functions ]]; then
   source ~/lib/shell/zsh/my_shell_functions
fi

if [[ "$OS" = "Windows_NT" ]]
then
    export PATH=/cygdrive/c/tools/scm/MSysGit/bin:$PATH
fi


# ===magic mv
autoload -U zmv


# ===load completion system
# autoload -Uz compinit
# for dump in ~/.zcompdump(N.mh+24); do
#   compinit
# done
# compinit -C

# autoload -U compinit
# if [ -n "$OS" -a "$OS" = "Windows_NT" ]
# then
#     compinit -u
#     export PATH=$PATH:/cygdrive/c/tools/bin
# else
#     compinit
# fi

# ===load completion list module
zmodload zsh/complist

# ===load zsh datetime module===
zmodload zsh/datetime

# === zsh/sched module ===
zmodload zsh/sched

# if [[ -e ~/.oh-my-zsh/plugins/aws/aws.plugin.zsh ]]; then
#   source ~/.oh-my-zsh/plugins/aws/aws.plugin.zsh
# fi

# === backward delete all the way to slash
backward-delete-to-slash () {
  local WORDCHARS=${WORDCHARS//\//}
  zle .backward-delete-word
}
zle -N backward-delete-to-slash

autoload -Uz colors
colors

rbenv() {
  eval "$(rbenv init -)"
  export PATH="/opt/chefdk/bin:$PATH"
}

# Autoload some bash completion functions if they exist.
autoload -Uz bashcompinit
bashcompinit

autoload -Uz is-at-least

fpath=(
        $fpath
        ~/.zen/zsh/scripts
        ~/.zen/zsh/zle
       ~/.zfunctions )
autoload -U zen

[[ -s `brew --prefix`/etc/autojump.sh  ]] && . `brew --prefix`/etc/autojump.sh
eval `keychain --eval --agents ssh --inherit any id_rsa`

which pyenv 2>&1 > /dev/null
if [[ $? == 0 ]]; then
  echo initialize pyenv ...
  eval "$(pyenv init --path)"
fi

which pyenv-virtualenv-init 2>&1 > /dev/null
if [[ $? == 0 ]]; then
  echo "initialize pyenv virtualenv"
  eval "$(pyenv virtualenv-init -)"
fi

which hub 2>&1 > /dev/null
if [[ $? == 0 ]]; then
  echo 'initialize hub'
  eval "$(hub alias -s)"
fi

if [[ -e ~/perl5/perlbrew/etc/bashrc ]]; then
  source ~/perl5/perlbrew/etc/bashrc
fi

if [[ -e /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi

if [[ -e ~/tools/rundeck ]]; then
  export RUNDECK_BASE=~/tools/rundeck/tools
  export RUNDECK_TOOL_BIN=$RUNDECK_BASE/bin
  export PATH=$PATH:$RUNDECK_TOOL_BIN
fi

if [[ -e $(brew --prefix nvm) ]]; then
  if [[ ! -e ~/.nvm ]]; then
    mkdir -p ~/.nvm
  fi
  export NVM_DIR=~/.nvm
  source $(brew --prefix nvm)/nvm.sh
fi

unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

autoload -U promptinit; promptinit
# prompt spaceship

export SPACESHIP_TIME_SHOW=true

if [[ -e /opt/puppetlabs/pdk ]]; then
    export PATH=$PATH:/opt/puppetlabs/pdk/bin
fi

which goenv 2>&1 > /dev/null
if [[ $? == 0 ]]; then
    echo initialize go env
    eval "$(goenv init -)"
fi

# make gcloud autocompletion work
if [[ -e $BREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc ]]; then
     source $BREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi

# which fasd
# if [[ $? == 0 ]]; then
#     eval "$(fasd --init posix-alias zsh-hook)"
# fi

# enable hal commands completion
if [[ -e ~/.zsh/hal_completion ]]; then
    source ~/.zsh/hal_completion
fi

# which starship 2>&1 > /dev/null
# if [[ $? == 0 ]]; then
#     eval "$(starship init zsh)"
# fi

if [[ -e $BREW/bin/direnv ]]; then
    eval "$(direnv hook zsh)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -e $BREW_ROOT/share/antigen/antigen.zsh ]]; then
  echo loading antigen
    source $BREW_ROOT/share/antigen/antigen.zsh
fi

if [[ -e $BREW_ROOT/opt/fzf/shell/key-bindings.zsh ]]; then
  echo load fzf key-bindings script
    source $BREW_ROOT/opt/fzf/shell/key-bindings.zsh
fi

if [[ -e $BREW_ROOT/opt/fzf/shell/completion.zsh ]]; then
  echo loading fzf auto complete script
    source $BREW_ROOT/opt/fzf/shell/completion.zsh
fi

if [[ -r $HOME/.smartcd_config ]]; then
    echo loading smartcd config
    source ~/.smartcd_config
fi

if [[ $BREW_ROOT/bin/thefuck ]]; then
  eval $(thefuck --alias)
fi
