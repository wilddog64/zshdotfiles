# for XWin ...
if [[ -z $DISPLAY && -z $SSH_CONNECTION ]]; then
    disp_no=($( ps -xww | grep -F X11.app | awk '{print $NF}' | grep -e ":[0-9]"  ))
    if [[ -n $disp_no ]];then
        export DISPLAY=${disp_no}.0
    else
        export DISPLAY=:0.0
    fi
    echo "DISPLAY has been set to $DISPLAY"
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
export HISTSIZE=10000                # lines to be saved
export SAVEHIST=5000
setopt HIST_EXPIRE_DUPS_FIRST        # replace the oldest history event that is duplicated
setopt HIST_FIND_NO_DUPS             # do not find duplicated commands
setopt HIST_IGNORE_ALL_DUPS          # ignore all duplication commands
setopt HIST_IGNORE_SPACE             # ignore line begin with space - will not be put into history file when next command is executed
setopt HIST_REDUCE_BLANKS            # remove superfluous blanks from each command line being added to the history list
setopt HIST_SAVE_NO_DUPS             # do not write dup command into history
setopt HIST_VERIFY                   # make history expansion, substution, ... appear on the command line
setopt INC_APPEND_HISTORY            # append history as the order of command is executed
setopt SHARE_HISTORY                 # make history share amount different zsh sessions
setopt EXTENDED_HISTORY              # enable timestamp with history
setopt HIST_FCNTL_LOCK               # use OS provide fcntl library

DIRSTACKSIZE=10
setopt AUTO_PUSHD
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME

# zsh regex
setopt EXTENDED_GLOB        # Enable extended globbing

# === I/O options
setopt HASH_CMDS # remeber location of each command when it's first executed, and later use that
setopt PATH_DIRS # perform a path search even on command names with slashes in them
setopt MULTIOS   # Allow multiple redirection echo 'a'>b>c

# === job control
setopt AUTO_CONTINUE                 # stopped jobs that are removed from job table used disown command are automatically send a CONT signal

# === options for completion
# setopt MENU_COMPLETE                 # turn on menu completion
setopt COMPLETE_IN_WORD              # complete in the middle of a word
setopt REC_EXACT                     # recognize exact match in completion
setopt ALWAYS_TO_END                 # always move cursor to the end after completion

setopt PRINT_EIGHT_BIT
unsetopt AUTO_PUSHD

# let system know where is rbenv
export RBENV_ROOT=/usr/local/var/rbenv

# === options for jobs
setopt AUTO_RESUME

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


# === load zsh modules
autoload -U promptinit # custom prompt
promptinit
prompt clint

# ===magic mv
autoload -U zmv


# ===load completion system

autoload -U compinit
if [ -n "$OS" -a "$OS" = "Windows_NT" ]
then
    compinit -u
else
    compinit
fi

# if [ -r $CTL_HOME/etc/bash_completion.sh ]
# then
#     autoload bashcompinit
#     source $CTL_HOME/etc/bash_completion.sh
# fi

# ===load completion list module
zmodload zsh/complist

# ===load zsh datetime module===
zmodload zsh/datetime

# === zsh/sched module ===
zmodload zsh/sched

# all the windows related settings should be in this block
if [ -n "$OS" -a "$OS" = "Windows_NT" ]
then
    export PATH=$PATH:/cygdrive/c/tools/bin
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
# Autoload some bash completion functions if they exist.
autoload -Uz bashcompinit
bashcompinit

autoload -Uz is-at-least

fpath=(
        $fpath
        /Users/cliang/.zen/zsh/scripts
        /Users/cliang/.zen/zsh/zle )
autoload -U zen
