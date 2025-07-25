# make cursor shown at the end of command line when recall history
unsetopt global_rcs

# === for hoembrew environment
export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/usr/local/share/info:${INFOPATH:-}";

# === user specific environment variables: path, perl library, and ruby
export USER_BIN=~/bin
export LESS_ADVANCED_PREPROCESSOR=1
export LESSCLOSE="lessclose.sh %s %s"
export GREP_COLOR=auto
export FTP_PASSIVE=1
export AUTOJUMP_KEEP_SYMLINKS=1
export TOUCHBAR_GIT_ENABLED=true
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

export PATH=/usr/local/bin:$USER_BIN:$PATH

PUPPET_HOME=/opt/puppetlabs/puppet
PUPPET_BIN=$PUPPET_HOME/bin
export PATH=$PUPPET_BIN:$PATH

which brew 2>&1 > /dev/null
if [[ $? == 0 ]] ; then
   eval $(brew shellenv)
   # setup homebrew environment variables
   export BREW_ROOT=$(brew --prefix)
   export HOMEBREW_BIN=$HOMEBREW_PREFIX/bin
   export HOMEBREW_SBIN=$HOMEBREW_PREFIX/sbin
   export FZF_BASE=$HOMEBREW_PREFIX/opt/fzf
   export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
   export HOMEBREW_NO_INSTALL_CLEANUP=1
   export HOMEBREW_GITHUB_API_TOKEN=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
   export PHPBREW_SET_PROMPT=1
   export PHPBREW_RC_ENABLE=1
   export HOMEBREW_NO_AUTO_UPDATE=1
   export MONO_GAC_PREFIX=$BREW_ROOT
   export GNUBIN=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin

   export GROOVY_HOME=$HOMEBREW_PREFIX/opt/groovy/libexec
   export GROOVY_HOME=/usr/local/opt/groovy/libexec
   export EDITOR=$HOMEBREW_PREFIX/bin/nvim
   export VISUAL=$HOMEBREW_PREFIX/bin/nvim
   export DOTNET_PATH=$HOMEBREW_PREFIX/share/dotnet
   export POSTGRES_BIN=$HOMEBREW_PREFIX/opt/libpq/bin
   export OPENSSL_BIN=$HOMEBREW_PREFIX/opt/openssl/bin
   export GTAR_PATH=$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin
   export PATH=$GTAR_PATH:$OPENSSL_BIN:$DOTNET_PATH:$HOMEBREW_BIN:$GNUBIN:$HOMEBREW_BIN:$HOMEBREW_SBIN:$GIT_CONTRIB:$PATH:$PUPPET_BOLT:~/bin:$POSTGRES_BIN
   export LESSOPEN="|$BREW_ROOT/bin/lesspipe.sh %s"
   export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
fi
# populate homebrew enviornment variables
# === make command line editing like vi, ya ya ya!!!
# export ZSH_THEME=powerlevel10k
export ZSH_THEME=agnoster
set -o vi

# === for groovy

# === locale language settings
export LANG=en_US.UTF-8

# === do not record command that's in the history already
export HISTCONTROL=both

# === this will allow pbcopy work fine with acent characters
export __CF_USER_TEXT_ENCODING=0x1F5:0x8000100:0x8000100

# === for temprary working directory
export TMP=/tmp
export TMPDIR=/tmp

# export ZDOTDIR=/Users/chengkai.liang/src/gitrepo/personal/zshdotfiles/
# === theme ===

# === Favoir Editor ===
# autoload -Uz compinstall && compinstall

# === export JAVA_HOME enviornment variable ===
export JAVA_HOME=/usr

# export GIT_CONTRIB=/usr/local/Cellar/git/1.9.0/share/git-core/contrib

# setup GROOVY_HOME environment variable


# for docker client
# /usr/local/opt/coreutils/libexec/gnubin

export GOENVGOROOT=$HOME/.goenvs
export GOENVTARGET=$HOME/go/bin
export GOENVHOME=$HOME/workspace
export PATH=$GTAR_PATH:$OPENSSL_BIN:$DOTNET_PATH:$GNUBIN:$GIT_CONTRIB:$PATH:$GOENVTARGET:~/bin
# zsh auto-suggestion higlight style
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=gray,bold,underline"

# MONO assembly

# for AWS CLI to access Instance Meta Data Service (IMDS)
export NO_PROXY=169.254.169.254

# make zsh vim mode faster
export KEYTIMEOUT=1

export VAULT_ADDR=https://vault.sea.bigfishgames.com
if [[ ! -e ~/.zsh_history ]]; then
    mkdir -p ~/.zsh_history
fi

# if [[ -z $DISPLAY && -z $SSH_CONNECTION ]]; then
#     disp_no=($( ps -xww | grep -F X11.app | awk '{print $NF}' | grep -e ":[0-9]"  ))
#     if [[ -n $disp_no ]];then
#         export DISPLAY=${disp_no}.0
#     else
#         export DISPLAY=:0.0
#     fi
#     echo "DISPLAY has been set to $DISPLAY"
# fi

# for phpbrew
if [[ -e $HOME/.phpbrew/bashrc ]]; then
    source $HOME/.phpbrew/bashrc
fi


# === options for customizing zsh behavior
setopt AUTO_NAME_DIRS
setopt -J                   # set AUTO_CD
setopt -E                   # push silent - won't print when doing pushd/popd
# setopt -Y                   # menu completion
setopt -Q                   # perform a path search even / in a string

setopt CDABLE_VARS          # expand an argument for CD if it is not a directory or does not begin with '/'.  Expand it as it was preceded by '~'
setopt PUSHD_IGNORE_DUPS    # don't push duplicate old directory
                            # insert the first match immdiately.
setopt -8                   # Append a trailing '/' to all directory names.
setopt NOTIFY               # make shell notify background job immediately after they luanched
unsetopt correct_all        # stop auto correct feature

# === command line history options
export HISTFILE=~/.zsh/history  # history file
export HISTSIZE=10000           # lines to be saved
export SAVEHIST=5000
setopt HIST_EXPIRE_DUPS_FIRST   # replace the oldest history event that is duplicated
setopt HIST_FIND_NO_DUPS        # do not find duplicated commands
setopt HIST_IGNORE_ALL_DUPS     # ignore all duplication commands
setopt HIST_IGNORE_SPACE        # ignore line begin with space - will not be put into history file when next command is executed
setopt HIST_REDUCE_BLANKS       # remove superfluous blanks from each command line being added to the history list
setopt HIST_SAVE_NO_DUPS        # do not write dup command into history
setopt HIST_VERIFY              # make history expansion, substution, ... appear on the command line
setopt INC_APPEND_HISTORY       # append history as the order of command is executed
setopt SHARE_HISTORY            # make history share amount different zsh sessions
setopt EXTENDED_HISTORY         # enable timestamp with history
setopt HIST_FCNTL_LOCK          # use OS provide fcntl library
setopt AUTO_PUSHD
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME

DIRSTACKSIZE=10

# zsh regex
setopt EXTENDED_GLOB        # Enable extended globbing

# === I/O options
setopt HASH_CMDS # remeber location of each command when it's first executed, and later use that
setopt PATH_DIRS # perform a path search even on command names with slashes in them
setopt MULTIOS   # Allow multiple redirection echo 'a'>b>c

# === job control
setopt AUTO_CONTINUE         # stopped jobs that are removed from job table used disown command are automatically send a CONT signal

# === options for completion
# setopt MENU_COMPLETE       # turn on menu completion
setopt COMPLETE_IN_WORD      # complete in the middle of a word
setopt REC_EXACT             # recognize exact match in completion
setopt ALWAYS_TO_END         # always move cursor to the end after completion

setopt PRINT_EIGHT_BIT

# === options for jobs
setopt AUTO_RESUME


# === this will alow backward-kill-word to only eimilate one component in a path instead of the whole path
export WORDCHARS=${WORDCHARS//\//}

# so we can have lazygit applied vim editing style
which oh-my-posh 2>&1 > /dev/null
if [[ $? == 0 ]]; then
   export LZG_KEYBIND_MODE=vim
   eval $(oh-my-posh init zsh)
fi
