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

zplug "b4b4r07/zsh-vimode-visual", defer:3
zplug "cxreg/smartcd", from:github, hook-build: "make install; ln -sf ~/.zsh/smartcd_config ~/.smartcd_config"
zplug "greymd/tmux-xpanes", as:command, use:"bin/xpanes"
zplug "lib/clipboard", from:oh-my-zsh
zplug "mogensen/keychain", as:command, hook-build:"ln -sf $ZPLUG_REPOS/mogensen/keychain/keychain.sh $ZPLUG_BIN/keychain.sh"
zplug "plugins/azure", from:oh-my-zsh
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/dotnet", from:oh-my-zsh
zplug "plugins/gh", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/helm", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/per-directory-history", from:oh-my-zsh
zplug "plugins/terraform", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "pyenv/pyenv", from:github, hook-build: "ln -sf $ZPLUG_REPOS/pyenv/pyenv ~/.pyenv"
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug 'hlissner/zsh-autopair', as:plugin
zplug romkatv/powerlevel10k, as:theme, depth:1
