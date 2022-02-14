#!/usr/bin/env zsh
emulate -L zsh

if [[ "${OSTYPE}" == darwin* ]] && (( ${+commands[pbcopy]} )) && (( ${+commands[pbpaste]} )); then
   pbpaste;
elif [[ "${OSTYPE}" == (cygwin|msys)* ]]; then
   cat /dev/clipboard;
elif [ -n "${WAYLAND_DISPLAY:-}" ] && (( ${+commands[wl-copy]} )) && (( ${+commands[wl-paste]} )); then
   wl-paste;
elif [ -n "${DISPLAY:-}" ] && (( ${+commands[xclip]} )); then
   xclip -out -selection clipboard;
elif [ -n "${DISPLAY:-}" ] && (( ${+commands[xsel]} )); then
   xsel --clipboard --output;
elif (( ${+commands[lemonade]} )); then
   lemonade paste;
elif (( ${+commands[doitclient]} )); then
   doitclient wclip -r;
elif (( ${+commands[win32yank]} )); then
   win32yank -o;
elif [[ $OSTYPE == linux-android* ]] && (( $+commands[termux-clipboard-set] )); then
   termux-clipboard-get;
elif [ -n "${TMUX:-}" ] && (( ${+commands[tmux]} )); then
   tmux save-buffer -;
elif [[ $(uname -r) = *icrosoft* ]]; then
   powershell.exe -noprofile -command Get-Clipboard;
fi
