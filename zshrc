# for XWin ...

# === get all apps and create an aliases for them

# === for normal aliases
if [[ -r ~/.zsh/aliases ]]; then
    source ~/.zsh/aliases
fi

# === Cocoa Applications
if [[ -r /.zsh/apps_aliases ]]; then
  source ~/.zsh/apps_aliases
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
if [[ -r ~/.zsh/zsh_bindingkeys ]]; then
    source ~/.zsh/bindingkeys
fi

# === zsh completion styles
if [[ -r ~/.zsh/zsh_comp_styles ]]; then
    source ~/.zsh/comp_styles
fi

if [[ -r ~/.zsh/rdp.aliases ]]; then
    source ~/.zsh/rdp.aliases
fi

if [[ -r ~/.zsh/bindingkeys ]]; then
    source ~/.zsh/bindingkeys
fi

# source rvm file if it existed
if [[ -r ~/.rvm/scripts/rvm ]]; then
    source /home/chengkai/.rvm/scripts/rvm
fi

# initialize docker
if [[ $(which docker-machine) == 0 ]]; then
	eval $(docker-machine env)
fi

# === generate osx app aliases dynamically when new shell
# defaults domains 2>&1 |  defaults domains 2>&1 | perl -F', ' -a -nle 'print map { $_ =~ s/\s+//g; $prg = (split /\./)[-1]; print qq{ alias $prg="start -i $_" } if length $_ > 0 } @F' | grep -v 1 | awk -F: '{ print $2 }' > ~/.zsh/osx_app.aliases
if [[ -r ~/.zsh/osx_app.aliases ]]; then
   source ~/.zsh/osx_app.aliases
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

autoload -U compinit
if [ -n "$OS" -a "$OS" = "Windows_NT" ]
then
    compinit -u
    export PATH=$PATH:/cygdrive/c/tools/bin
else
    compinit
fi

# ===load completion list module
zmodload zsh/complist

# ===load zsh datetime module===
zmodload zsh/datetime

# === zsh/sched module ===
zmodload zsh/sched

if [[ -e ~/.oh-my-zsh/plugins/aws/aws.plugin.zsh ]]; then
  source ~/.oh-my-zsh/plugins/aws/aws.plugin.zsh
fi

# === backward delete all the way to slash
backward-delete-to-slash () {
  local WORDCHARS=${WORDCHARS//\//}
  zle .backward-delete-word
}
zle -N backward-delete-to-slash

autoload -Uz colors
colors

eval "$(rbenv init -)"
export PATH="/opt/chefdk/bin:$PATH"

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
# eval `keychain --eval --agents ssh --inherit any id_rsa`

which pyenv 2>&1 > /dev/null
if [[ $? == 0 ]]; then
  echo initialize pyenv ...
  eval "$(pyenv init -)"
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

if [[ -f $HOME/.smartcd/lib/core/smartcd ]]; then
  # TODO: handle system-wide install?
  echo 'initializing smartcd'
  source $HOME/.smartcd/lib/core/smartcd
  [[ -f $HOME/.smartcd_config ]] && source $HOME/.smartcd_config
else
  echo 'smartcd not installed yet!  Run "make install" or follow the README instructions'
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

if [[ -z "$TMUX" && "$SSH_CONNECTION" != "" ]]; then
    tmx work
fi
