# zplug "lib/directories", from:oh-my-zsh
# zplug "paulirish/git-open", as:plugin
# zplug "plugins/aws", from:oh-my-zsh
# zplug "plugins/docker", from:oh-my-zsh
# zplug "plugins/kitchen", from:oh-my-zsh
# zplug "plugins/kops", from:oh-my-zsh
# zplug "plugins/vagrant", from:oh-my-zsh
# zplug "theme/agnoster", from:oh-my-zsh, as:theme
# zplug "wfxr/forgit", from:github, as:command, hook-build: "ln -sf $ZPLUG_REPOS/wfxr/forgit/bin/git-forgit $ZPLUG_HOME/bin"
# zplug "zsh-users/vi-mode", from:oh-my-zsh
# zplug 'jeffreytse/zsh-vi-mode', as:plugin
# zplug 'junegunn/fzf-git.sh', as:plugin
# zplug 'mfaerevaag/wd', as:plugin

# --- zplug declarations ---
# theme (use p10k instant prompt for fastest feel)
zplug "romkatv/powerlevel10k", as:theme, depth:1

# vi mode indicator
zplug "b4b4r07/zsh-vimode-visual", defer:3

# smartcd (build once, then lazy load)
zplug "cxreg/smartcd", from:github, hook-build:"make install; ln -sf ~/.zsh/smartcd_config ~/.smartcd_config", defer:2

# commands
zplug "greymd/tmux-xpanes", as:command, use:"bin/xpanes"
zplug "mogensen/keychain", as:command, hook-build:"ln -sf $ZPLUG_REPOS/mogensen/keychain/keychain.sh $ZPLUG_BIN/keychain.sh"
zplug "github/hub", as:command, use:"bin/hub", hook-build:"script/build"

# OMZ libs (tiny)
zplug "lib/clipboard", from:oh-my-zsh, defer:2
zplug "lib/directories", from:oh-my-zsh, defer:2

# OMZ plugins (guard by tool presence to avoid wasted work)
zplug "plugins/brew",       from:oh-my-zsh, if:"type brew     >/dev/null 2>&1", defer:2
zplug "plugins/gh",         from:oh-my-zsh, if:"type gh       >/dev/null 2>&1", defer:2
zplug "plugins/git",        from:oh-my-zsh,                                defer:2
zplug "plugins/azure",      from:oh-my-zsh, if:"type az       >/dev/null 2>&1", defer:2
zplug "plugins/dotnet",     from:oh-my-zsh, if:"type dotnet   >/dev/null 2>&1", defer:2
zplug "plugins/terraform",  from:oh-my-zsh, if:"type terraform>/dev/null 2>&1", defer:2
zplug "plugins/helm",       from:oh-my-zsh, if:"type helm     >/dev/null 2>&1", defer:2
zplug "plugins/kubectl",    from:oh-my-zsh, if:"type kubectl  >/dev/null 2>&1", defer:2
zplug "plugins/per-directory-history", from:oh-my-zsh, defer:2
zplug "plugins/z",          from:oh-my-zsh, defer:2

# autosuggest + syntax highlight (keep these near the end; high defer)
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "hlissner/zsh-autopair", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:3

# pyenv (don’t initialize eagerly; create a lazy stub)
zplug "pyenv/pyenv", from:github, hook-build:"ln -sf $ZPLUG_REPOS/pyenv/pyenv ~/.pyenv", defer:3
