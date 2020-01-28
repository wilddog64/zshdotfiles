#!/bin/bash -
#===============================================================================
#
#          FILE: tmxkillf.sh
#
#         USAGE: ./tmxkillf.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (),
#  ORGANIZATION:
#       CREATED: 01/28/2020 13:19:29
#      REVISION:  ---
#===============================================================================
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

