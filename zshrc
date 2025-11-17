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

if command -v vault >/dev/null 2>&1; then
   complete -o nospace -C $(which vault) vault
fi

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

if [[ -z ${ZSH_FZF_LOADED:-} ]]; then
   for _fzf_src in \
      "${HOMEBREW_PREFIX:-}/opt/fzf/shell/key-bindings.zsh" \
      "/usr/local/opt/fzf/shell/key-bindings.zsh" \
      "${HOME}/.fzf/shell/key-bindings.zsh" \
      "${HOME}/.zsh/fzf-shell/key-bindings.zsh"
   do
      if [[ -r $_fzf_src ]]; then
         echo "loading fzf key-bindings from $_fzf_src"
         source "$_fzf_src"
         export ZSH_FZF_LOADED=1
         break
      fi
   done
   unset _fzf_src
fi

# === zsh completion styles
if [[ -r ~/.zsh/zsh_comp_styles ]]; then
    source ~/.zsh/comp_styles
fi

# initialize docker
if command -v docker-machine >/dev/null 2>&1; then
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

if [[ ! -e ~/.zplug/init.zsh ]]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

ZSH_OFFICE_RC="${ZSH_OFFICE_RC:-${ZDOTDIR:-$HOME/.zsh}/office/zshrc}"
if [[ -z ${ZSH_PROFILE:-} && -f "$ZSH_OFFICE_RC" ]]; then
  export ZSH_PROFILE=office
fi
if [[ ${ZSH_PROFILE:-} == office && -f "$ZSH_OFFICE_RC" ]]; then
  source "$ZSH_OFFICE_RC"
fi

if command -v hub >/dev/null 2>&1; then
  echo 'initialize hub'
  eval "$(hub alias -s)"
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

if command -v gh >/dev/null 2>&1; then
   echo load gh completion
   eval "$(gh completion -s zsh)"
fi

if command -v yq >/dev/null 2>&1; then
   if [[ -f $HOME/.zsh/scripts/yq.complete.zsh ]]; then
      echo source yq completion
      source $HOME/.zsh/scripts/yq.complete.zsh
   else
      echo load yq zsh auto completion
      eval "$(yq shell-completion zsh)" >/dev/null 2>&1
   fi
fi
