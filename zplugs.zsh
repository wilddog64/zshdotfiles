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

# Lightweight replacements
zplug "rupa/z", use:z.sh, defer:2
zplug "jimhester/per-directory-history", defer:2

# autosuggest + syntax highlight (keep these near the end; high defer)
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "hlissner/zsh-autopair", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:3

# pyenv (don’t initialize eagerly; create a lazy stub)
zplug "pyenv/pyenv", from:github, hook-build:"ln -sf $ZPLUG_REPOS/pyenv/pyenv ~/.pyenv", defer:3
