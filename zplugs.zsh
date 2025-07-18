zplug "theme/agnoster", from:oh-my-zsh, as:theme
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/per-directory-history", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/terraform", from:oh-my-zsh
zplug "plugins/dotnet", from:oh-my-zsh
zplug "plugins/gh", from:oh-my-zsh
zplug "plugins/kops", from:oh-my-zsh
zplug "plugins/vagrant", from:oh-my-zsh
zplug "plugins/kitchen", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/vi-mode", from:oh-my-zsh
zplug "zsh-users/kubectl", from:oh-my-zsh, as:plugin
zplug "mogensen/keychain", as:command, hook-build:"ln -sf $ZPLUG_REPOS/mogensen/keychain/keychain.sh $ZPLUG_BIN/keychain.sh"
zplug "lib/clipboard", from:oh-my-zsh
zplug "b4b4r07/zsh-vimode-visual", defer:3
zplug "lib/directories", from:oh-my-zsh
zplug "greymd/tmux-xpanes", as:command, use:"bin/xpanes"
zplug "cxreg/smartcd", from:github, hook-build: "make install; ln -sf ~/.zsh/smartcd_config ~/.smartcd_config"
zplug "pyenv/pyenv", from:github, hook-build: "ln -sf $ZPLUG_REPOS/pyenv/pyenv ~/.pyenv"
zplug "wfxr/forgit", from:github, as:command, hook-build: "ln -sf $ZPLUG_REPOS/wfxr/forgit/bin/git-forgit $ZPLUG_HOME/bin"
zplug "paulirish/git-open", as:plugin
zplug 'mfaerevaag/wd', as:plugin
zplug 'hlissner/zsh-autopair', as:plugin
zplug romkatv/powerlevel10k, as:theme, depth:1
