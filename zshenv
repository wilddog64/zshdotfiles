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

# === for JAVA
# export JAVA_HOME=/usr
export JAVA_HOME=/Library/Java/Home
export JAVAROOT=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home

# === for temprary working directory
export TMP=/tmp
export TMPDIR=/tmp

# === theme ===
export ZSH_THEME=cloud

# === Favoir Editor ===
export EDITOR=vi
# autoload -Uz compinstall && compinstall

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
