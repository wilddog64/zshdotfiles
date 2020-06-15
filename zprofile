# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [ -x /usr/libexec/path_helper ]; then
	eval `/usr/libexec/path_helper -s`
fi

[[ -s "/etc/profile.d/rvm.sh" ]] && . /etc/profile.d/rvm.sh
[[ -s "/Users/cliang/src/gitrepo/chruby/share/chruby/chruby.sh" ]] && . /Users/cliang/src/gitrepo/chruby/share/chruby/chruby.sh
[[ -s "/Users/cliang/src/gitrepo/chruby/share/chruby/auto.sh" ]] && . /Users/cliang/src/gitrepo/chruby/share/chruby/auto.sh
