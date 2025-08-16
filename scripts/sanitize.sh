#!/usr/bin/env bash
cat "$@" | sed -E -f ~/.zsh/sanitize.sed
