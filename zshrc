# for XWin ...

{
  # Compile zcompdump, if modified, to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# Set Spaceship ZSH as a prompt
# autoload -U promptinit; promptinit
# prompt spaceship
autoload -U +X bashcompinit && bashcompinit

# [ -r "$HOME/.smartcd_config" ] && ( [ -n $BASH_VERSION ] || [ -n $ZSH_VERSION ] ) && source ~/.smartcd_config

complete -o nospace -C /usr/local/bin/vault vault

source ~/.zsh/bindingkeys
# zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if [[ -r ~/.p10k.zsh ]]; then
   source ~/.p10k.zsh
   typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
fi


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

# if [[ -r ~/.zsh/fzf.zsh ]]; then
#   source ~/.zsh/fzf.zsh
# fi

# === key bindings
if [[ -r ~/.zsh/bindingkeys ]]; then
    echo load keybinding
    source ~/.zsh/bindingkeys
fi

command -v fzf 2>&1 > /dev/null
echo loading fzf key-bindings for zsh
source ~/.zsh/fzf-shell/key-bindings.zsh

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

# ===load completion list module
zmodload zsh/complist

# ===load zsh datetime module===
zmodload zsh/datetime

# === zsh/sched module ===
zmodload zsh/sched

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

if [[ -z $IS_MAC ]]; then
   eval `keychain ~/.ssh/id_rsa`
elif [[ -n $IS_MAC ]]; then
   eval `keychain ~/.ssh/id_ed25519`
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

if [[ -n $BREW_EXIST ]] && [[ -e $(brew --prefix nvm) ]]; then
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
if [[ -e $HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc ]]; then
     source $HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi

# which starship 2>&1 > /dev/null
# if [[ $? == 0 ]]; then
#     eval "$(starship init zsh)"
# fi

if [[ -e $HOMEBREW_PREFIX/bin/direnv ]]; then
    eval "$(direnv hook zsh)"
fi

if [[ -e $HOMEBREW_PREFIX/share/antigen/antigen.zsh ]]; then
  echo loading antigen
    source $HOMEBREW_PREFIX/share/antigen/antigen.zsh
fi

if [[ -e $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh ]]; then
  echo load fzf key-bindings script
    source $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh
fi

if [[ -e $HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh ]]; then
  echo loading fzf auto complete script
    source $HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh
fi

if [[ -r $HOME/.smartcd_config ]]; then
    echo loading smartcd config
    source ~/.smartcd_config
fi

if [[ ! -e ~/.zplug/init.zsh ]]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
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

which gh 2>&1 > /dev/null
if [[ $? == 0 ]]; then
   echo load gh completion
   eval $(gh completion -s zsh)
fi

which eksctl 2>&1 > /dev/null
if [[ $? == 0 ]]; then
   echo loading eksctl completion
   eval $(eksctl completion zsh)
fi

which chef 2>&1 > /dev/null
if [[ $? == 0 ]]; then
   echo loading chef environment settings for zsh
   chef shell-init zsh > /tmp/chef_completion.zsh
   source /tmp/chef_completion.zsh
fi

which yq >/dev/null 2>&1
if [[ $? == 0 ]]; then
   if [[ -f $HOME/.zsh/scripts/yq.complete.zsh ]]; then
      echo source yq completion
      source $HOME/.zsh/scripts/yq.complete.zsh
   else
      echo load yq zsh auto completion
      eval $(yq shell-completion zsh) >/dev/null 2>&1
   fi

fi
