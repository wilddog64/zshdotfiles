# for XWin ...

# === get all apps and create an aliases for them


# === zsh shell functions
if [[ -r ~/.zsh/my_func.zsh ]]; then
    source ~/.zsh/my_func.zsh
fi

# === cd names as commands  --- very handy
if [[ -r ~/.zsh/cdnames ]]; then
    echo load cdnames
    source ~/.zsh/cdnames
fi

if [[ -r ~/.zsh/fzf.zsh ]]; then
  source ~/.zsh/fzf.zsh
fi

# === key bindings
if [[ -r ~/.zsh/bindingkeys ]]; then
    echo load keybinding
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
if [[ -e $HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc ]]; then
     source $HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
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

if [[ -e $HOMEBREW_PREFIX/bin/direnv ]]; then
    eval "$(direnv hook zsh)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -r $HOME/.smartcd_config ]]; then
    echo loading smartcd config
    source ~/.smartcd_config
fi

if [[ ! -e ~/.zplug/init.zsh ]]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

if [[ -n "$TILIX_ID" ]] || [[ -n "$VTE_VERSION" ]]; then
  source /etc/profile.d/vte.sh
fi

sleep 3 # sleep one second for zplug to be ready
echo load zplug
source ~/.zplug/init.zsh
source ~/.zsh/zplugs.zsh
! zplug check --verbose  && zplug install
zplug load --verbose
set +o vi

# === for normal aliases, so we our aliases setup won't overwrite by zplug
if [[ -r ~/.zsh/aliases ]]; then
    echo load aliases
    source ~/.zsh/aliases
fi

export PATH=~/bin:$PATH
set -o vi
