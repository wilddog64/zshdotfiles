zplug "theme/agnoster", from:oh-my-zsh, as:theme
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/per-directory-history", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/aws", from:oh-my-zsh
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/terraform", from:oh-my-zsh
zplug "plugins/dotnet", from:oh-my-zsh
zplug "plugins/gh", from:oh-my-zsh
zplug "plugins/kops", from:oh-my-zsh
zplug "plugins/vagrant", from:oh-my-zsh
zplug "plugins/terraform", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
# zplug "zsh-users/vi-mode", from:oh-my-zsh
zplug "mogensen/keychain", as:command, hook-build:"ln -sf $ZPLUG_REPOS/mogensen/keychain/keychain.sh $ZPLUG_BIN/keychain.sh"
zplug "lib/clipboard", from:oh-my-zsh
zplug "Jxck/dotfiles", as:command, use:"bin/{histuniq,color}"
zplug "junegunn/fzf", as:command, hook-build:"make install", use:"bin/fzf"
