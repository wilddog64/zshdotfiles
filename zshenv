# make cursor shown at the end of command line when recall history
unsetopt global_rcs

# === user specific environment variables: path, perl library, and ruby
export user_bin=~/bin
export LESSOPEN="| lesspipe.sh %s"
export GREP_COLOR=auto
export FTP_PASSIVE=1

# === make command line editing like vi, ya ya ya!!!
export VISUAL=vi
set -o vi

# === locale language settings
export LANG=en_US.UTF-8

# === do not record command that's in the history already
export HISTCONTROL=both

# === this will allow pbcopy work fine with acent characters
export __CF_USER_TEXT_ENCODING=0x1F5:0x8000100:0x8000100


# === for temprary working directory
export TMP=/tmp
export TMPDIR=/tmp

# === theme ===
export ZSH_THEME=cloud

# === Favoir Editor ===
export EDITOR=vi
# autoload -Uz compinstall && compinstall

# === export JAVA_HOME enviornment variable ===
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home

export GIT_CONTRIB=/usr/local/Cellar/git/1.8.5.2/share/git-core/contrib
export BREW_ROOT=/usr/local
export BREW_BIN=$BREW_ROOT/bin
export BREW_SBIN=$BREW_ROOT/sbin
PATH=$BREW_BIN:$BREW_SBIN:$PATH:~/bin:$veewee_bin:$GIT_CONTRIB # Add RVM to PATH for scripting
