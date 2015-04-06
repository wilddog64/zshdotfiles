zman() {
    PAGER="less -g -s '+/^       "$1"'" man zshall
}

# _is_this_a_git_repo: is a utility function that will verify
# if current directory is a valid git repo.  The function check
# if current directory has .git folder within.  It will abort the
# function if .git directory does not exist!
function _is_this_a_git_repo() {
    git_meta_dir=$(pwd)/.git

    if [[ ! -e $git_meta_dir ]]; then
        echo $(pwd) is not a git repo, abort!
        kill -INT $$
    fi
}

# kill_git_branch: is a bash function that will delete a merged branch base on master
kill_git_branch() {

    _is_this_a_git_repo
    git branch --merged | grep -v master | xargs git branch -d 2> /dev/null

}


# DIRSTACKSIZE=9
# DIRSTACKFILE=~/.zdirs
# if [[ ! -e $DIRSTACKFILE && ! -f $DIRSTACKFILE ]]; then
#     touch $DIRSTACKFILE
# fi
# if [[ -f $DIRSTACKFILE  ]] && [[ $#dirstack -eq 0  ]]; then
#       dirstack=( ${(f)"$(< $DIRSTACKFILE)"}  )
#         [[ -d $dirstack[1]  ]] && cd $dirstack[1] && cd $OLDPWD
# fi
# chpwd() {
#    local -a dirs; dirs=( "$PWD" ${(f)"$(< $DIRSTACKFILE)"}  )
#    print -l ${${(u)dirs}[0,$DIRSTACKSIZE]} >$DIRSTACKFILE
# }
