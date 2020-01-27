zman() {
    PAGER="less -g -s '+/^       "$1"'" man zshall
}

# zsh; needs setopt re_match_pcre. You can, of course, adapt it to your own shell easily.
# this function use fzf to filter a list sessions for user to kill off
tmuxkillf () {
    setopt re_match_pcre
    local sessions
    sessions="$(tmux ls|fzf --exit-0 --multi)"  || return $?
    local i
    for i in "${(f@)sessions}"
    do
        [[ $i =~ '([^:]*):.*' ]] && {
            echo "Killing $match[1]"
            tmux kill-session -t "$match[1]"
        }
    done
    unsetopt re_match_pcre
}
