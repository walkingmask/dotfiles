# PATH settings
# default path of Mac OS X is "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# ~/bin
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi
