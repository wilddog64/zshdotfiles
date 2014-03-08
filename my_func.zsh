zman() {
    PAGER="less -g -s '+/^       "$1"'" man zshall
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
