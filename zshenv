# make cursor shown at the end of command line when recall history
unsetopt global_rcs

# === user specific environment variables: path, perl library, and ruby
export user_bin=~/bin
export LESSOPEN="| lesspipe.sh %s"
export GREP_COLOR=auto
export FTP_PASSIVE=1
export AUTOJUMP_KEEP_SYMLINKS=1
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

# export GIT_CONTRIB=/usr/local/Cellar/git/1.9.0/share/git-core/contrib
export BREW_ROOT=/usr/local
export BREW_BIN=$BREW_ROOT/bin
export BREW_SBIN=$BREW_ROOT/sbin
export HOMEBREW_GITHUB_API_TOKEN=e8c8fef32db9d77fd84c45b23b9cf6e589815c79

# for docker client
export DOCKER_HOST=tcp://localhost:4243
export GNUBIN=/usr/local/opt/coreutils/libexec/gnubin

export PATH=$BREW_BIN:$GNUBIN:$BREW_BIN:$BREW_SBIN:~/bin:$GIT_CONTRIB:$PATH # Add RVM to PATH for scripting

# MONO assembly
export MONO_GAC_PREFIX=/usr/local

# for AWS CLI to access Instance Meta Data Service (IMDS)
export NO_PROXY=169.254.169.254

if [[ ! -e ~/.zsh_history ]]; then
    mkdir -p ~/.zsh_history
fi
export HISTORY_BASE=~/.zsh_history

# initialize perlbrew
if [[ -r ~/perl5/perlbrew/etc/bashrc ]]; then
    source ~/perl5/perlbrew/etc/bashrc
fi
