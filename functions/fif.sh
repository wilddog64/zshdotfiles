#!/bin/bash -
#===============================================================================
#
#          FILE: fif.sh
#
#         USAGE: ./fif.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (),
#  ORGANIZATION:
#       CREATED: 01/28/2020 13:29:07
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | \
      fzf --preview "highlight -O ansi -l {} 2> /dev/null | \
      rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || \
      rg --ignore-case --pretty --context 10 '$1' {}"
}

