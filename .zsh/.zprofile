## PATH settings

# default path of Mac OS X is "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# brew
if [ -d "/usr/local/sbin" ]; then
  export PATH="/usr/local/sbin:$PATH"
 fi
# ~/bin
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi
# anyenv
if [ -d $HOME/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - --no-rehash)"
fi
# pyenv-virtualenv
if [ -d $HOME/.anyenv/envs/pyenv/plugins/pyenv-virtualenv ]; then
  eval "$(pyenv virtualenv-init -)"
fi
# zplug
if [ -d /usr/local/opt/zplug ]; then
  export ZPLUG_HOME=/usr/local/opt/zplug
  source $ZPLUG_HOME/init.zsh
fi
