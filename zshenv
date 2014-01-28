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
export JAVA_HOME=/usr

# === export rundeck environment variables
# RDECK_HOME=/var/lib/rundeck/
# RDECK_BASE=/etc/rundeck
# export RDECK_HOME
# export RDECK_BASE
# export CLI_CP=$(find /var/lib/rundeck/cli -name \*.jar -printf %p:)
export veewee_home=/Users/cliang/src/gitrepo/personal/puppet/veewee
export veewee_bin=$veewee_home/bin

PATH=$PATH:$HOME/.rvm/bin:~/bin:$veewee_bin # Add RVM to PATH for scripting
