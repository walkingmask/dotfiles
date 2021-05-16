# for Mac OS X

## zsh setting files
# 1. global /etc/z*
# 2. local ~/.z*
## At login
# 1. zshenv    Environment variable
# 2. zprofile  exec only at login (PATH)
# 3. zshrc     several settings
# 4. zlogin    exec only at login
## At interactive
# 1. zshenv
# 2. zshrc
## At script
# 1. zshenv
## At logout
# 1. zlogout   exec only at logout


## locale

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"


## plugin

if type zplug-env > /dev/null 2>&1; then
    zplug "zsh-users/zsh-syntax-highlighting"
    zplug "zsh-users/zsh-completions"
    # zplug "mollifier/anyframe"
    zplug "b4b4r07/enhancd"
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
    # zplug load --verbose
    zplug load
fi


## standard setopt

setopt noautoremoveslash
setopt no_beep
setopt no_flow_control


## color setting

autoload -Uz colors
colors
local DEFAULT=%{$reset_color%}
local RED=%{$fg[red]%}
local GREEN=%{$fg[green]%}
local YELLOW=%{$fg[yellow]%}
local BLUE=%{$fg[blue]%}
local PURPLE=%{$fg[purple]%}
local CYAN=%{$fg[cyan]%}
local WHITE=%{$fg[white]%}

### colorful ls

export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

### colorful prompt

case ${UID} in
0)
    PROMPT="%B%F{001}[('e')('e')('e')]#%f%b "
    RPROMPT="%B%F{01}[%~]%f%b"
    PROMPT2="%B%F{001}[('e')('e')('e')< %_]#%f%b "
    RPROMPT2="%B%F{01}[%~]%f%b"
    SPROMPT="%B%F{001}[('e')('e')('e')< %r is correct? [n,y,a,e]:%f%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%F{001}${HOST%%.*} ${PROMPT}"
    ;;
*)
    PROMPT="%F{220}[('e')]$%f "
    RPROMPT="%F{220}[%~]%f"
    PROMPT2="%F{220}[('e')< %_]$%f "
    RPROMPT2="%F{220}[%~]%f"
    SPROMPT="%F{220}[('e')< %r is correct? [n,y,a,e]:%f "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%F{220}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
esac


## terminal title

echo -en "\033];${USER}@${HOST%%.*}\007"


## cd setting

DIRSTACKSIZE=100
setopt auto_cd
setopt auto_pushd


## correction

setopt correct
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [No/Yes/Abort/Edit]"


## aliases

alias rm="mv_trash"      # chenge "rm" to "/Users/$USER/bin/mv_trash"
alias ls="ls -G"
alias lv="ls -alhF"
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias rsync="rsync -avhzu --progress"
alias where="command -v"
alias j="jobs -l"
alias brew="env PATH=${PATH/\/Users\/$USER\/.anyenv\/envs\/*env\/shims:/} brew"
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias octave="/usr/local/octave/3.8.0/bin/octave-3.8.0"
alias ipcheck="curl ipinfo.io/ip"
alias ssh-config="cat $HOME/.ssh/config"
alias a2n="/usr/bin/python -c \"import sys;v=sys.argv;print ''.join(['%02d'%(ord(c)-96) for c in v[1].lower()]) if len(v)>1 else ''\""
alias mabiki="/usr/bin/python -c \"import sys;v=sys.argv;print ''.join([c for i,c in enumerate(v[1]) if not i%2]) if len(v)>1 else ''\""
alias uneri="/usr/bin/python -c \"import sys;v=sys.argv;print ''.join([c.upper() if i%2 else c.lower() for i,c in enumerate(v[1])]) if len(v)>1 else ''\""

### git

alias gsta='git status'
alias glog='git log'
alias gbra='git branch'
alias gche='git checkout'
alias gadd='git add'
alias gcom='git commit'
alias gpush='git push'
alias gpull='git pull'
alias gstash='PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin git stash'
alias grevert='PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin git revert'

### caffeine check and kill

alias cfc="ps aux | grep caff | grep -v grep"
alias cfk="pkill caffeinate"

### translate

alias ja2en="trans -b {ja=en}"
alias j2e="ja2en"
alias en2ja="trans -b {en=ja}"
alias e2j="en2ja"

### weather

alias weather="curl 'wttr.in/那覇?0'"

### wakeonlan tens

alias wolt="wakeonlan -i walkingmask.orz.hm bc:5f:f4:88:f6:0b"
alias woltl="wakeonlan bc:5f:f4:88:f6:0b"
alias ipynb2py="jupyter nbconvert --to script"

### look up ip in lan

alias ip_lookup="echo 192.168.0.{1..254} | xargs -P256 -n1 ping -s1 -c1 -W1 | grep ttl"

### notes and papers

alias research="$HOME/bin/notes research"
alias papers="open -g $HOME/dev/papers && open -na 'Google Chrome' --args --new-window https://github.com/walkingmask/papers/issues"


## alias -s

### http://itchyny.hatenablog.com/entry/20130227/1361933011
alias -s py=python
alias -s pl=perl
alias -s sh=sh
alias -s go="go run"
alias -s {png,jpg,bmp,PNG,JPG,BMP}=open
alias -s html=subl
function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
  esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract
# function runcpp () { g++ $1 && shift && ./a.out $@ }
# alias -s {c,cpp}=runcpp


## command history configuration

HISTFILE=${HOME}/.zsh_history
HISTSIZE=1000
SAVEHIST=100000
setopt hist_expand
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history

### historical backward/forward search with linehead string binded to ^P/^N

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end 

### reverse menu completion binded to Shift-Tab

bindkey "\e[Z" reverse-menu-complete

### incremental history search

setopt inc_append_history
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward


## completion configuration

autoload -U compinit
compinit

### setopt

setopt always_last_prompt
setopt auto_menu
setopt auto_param_keys
setopt auto_param_slash
setopt complete_aliases
setopt complete_in_word
setopt extended_glob
setopt globdots
setopt interactive_comments
setopt list_packed
setopt list_types
setopt magic_equal_subst
setopt mark_dirs
setopt print_eight_bit

### zstyle

zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format $YELLOW'%d'$DEFAULT
zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # match to uppercase when lowercase
zstyle ':completion:*' group-name ''
bindkey "^I" menu-complete


## hook functions

autoload -Uz add-zsh-hook

### keep awake while execution

function be_awake() {
    sh -c 'caffeinate -u -t 86400 & echo $!' | read CAFFPID$$
}
function be_ease() {
    eval CAFFPID='$CAFFPID'$$
    if [ "$CAFFPID" != "" ]; then
        if pgrep -f caffeinate | grep $CAFFPID >/dev/null; then
            kill $CAFFPID
            eval CAFFPID"$$"=""
        fi
    fi
}
function goodnight() {
    be_ease
}
add-zsh-hook preexec be_awake
add-zsh-hook precmd be_ease
add-zsh-hook zshexit goodnight

### peep!

function peeexec() {
    if [ -e $HOME/bin/peep ]; then
        ($HOME/bin/peep &)
    fi
}
add-zsh-hook precmd peeexec


## directory memory

### remember the last changed directory's PATH

function remeberpath() {
    echo $PWD >$HOME/.zcd
}
add-zsh-hook zshexit remeberpath

### go back to the previous working directory

[ -f $HOME/.zcd ] && cd `cat $HOME/.zcd`


## load experimental zsh configuration file

[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine
[ -f ${HOME}/.zshrc.peco ] && source ${HOME}/.zshrc.peco


## For Python

export PYTHONSTARTUP=~/.pythonstartup


## zmv http://mollifier.hatenablog.com/entry/20101227/p1

autoload -Uz zmv
alias zmv='noglob zmv -W'
