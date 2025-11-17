# make cursor shown at the end of command line when recall history
unsetopt global_rcs

# === shared zsh environment ===
export user_bin=~/bin
export LESS_ADVANCED_PREPROCESSOR=1
export LESSCLOSE="lessclose.sh %s %s"
export GREP_COLOR=auto
export FTP_PASSIVE=1
export AUTOJUMP_KEEP_SYMLINKS=1
export TOUCHBAR_GIT_ENABLED=true

# make editor behave like vi in readline-enabled prompts
set -o vi

# locale and encoding defaults
export LANG=en_US.UTF-8
export HISTCONTROL=both
export __CF_USER_TEXT_ENCODING=0x1F5:0x8000100:0x8000100

export TMP=/tmp
export TMPDIR=/tmp

export JAVA_HOME=/usr

# load phpbrew when present
if [[ -e $HOME/.phpbrew/bashrc ]]; then
    source $HOME/.phpbrew/bashrc
fi
export PHPBREW_SET_PROMPT=1
export PHPBREW_RC_ENABLE=1

# === options for customizing zsh behavior
setopt AUTO_NAME_DIRS
setopt -J                   # set AUTO_CD
setopt -E                   # push silent - won't print when doing pushd/popd
# setopt -Y                   # menu completion
setopt -Q                   # perform a path search even / in a string

setopt CDABLE_VARS
setopt PUSHD_IGNORE_DUPS
setopt -8
setopt NOTIFY
setopt correct_all

# === command line history options
export HISTFILE=~/.zsh/history
export HISTSIZE=10000
export SAVEHIST=5000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FCNTL_LOCK
setopt AUTO_PUSHD
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME

if [[ ! -e ~/.zsh_history ]]; then
    mkdir -p ~/.zsh_history
fi

DIRSTACKSIZE=10

# zsh regex
setopt EXTENDED_GLOB

# === I/O options
setopt HASH_CMDS
setopt PATH_DIRS
setopt MULTIOS

# === job control
setopt AUTO_CONTINUE

# === completion options
# setopt MENU_COMPLETE
setopt COMPLETE_IN_WORD
setopt REC_EXACT
setopt ALWAYS_TO_END
setopt PRINT_EIGHT_BIT

# === options for jobs
setopt AUTO_RESUME

# quality-of-life settings
export KEYTIMEOUT=1
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=gray,bold,underline"
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export LZG_KEYBIND_MODE=vim
export POSH_THEMES_PATH=~/.local/share/oh-my-posh/themes
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Office profile (disabled unless ZSH_PROFILE=office)
ZSH_OFFICE_ENV="${ZSH_OFFICE_ENV:-${ZDOTDIR:-$HOME/.zsh}/office/zshenv}"
if [[ -z ${ZSH_PROFILE:-} && -f "$ZSH_OFFICE_ENV" ]]; then
  export ZSH_PROFILE=office
fi
if [[ ${ZSH_PROFILE:-} == office && -f "$ZSH_OFFICE_ENV" ]]; then
  source "$ZSH_OFFICE_ENV"
fi
