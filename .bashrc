# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# chenge "rm" to "/Users/$USER/bin/mv_trash"
if [ -f ${HOME}/bin/mv_trash ]; then
	alias rm="mv_trash"
fi
