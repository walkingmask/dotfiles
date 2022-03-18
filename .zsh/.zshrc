# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zinit
ZINIT_HOME="${ZDOTDIR}/.zinit"
if [ ! -d $ZINIT_HOME ]; then
  mkdir $ZINIT_HOME
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit light-mode for \
  zdharma-continuum/z-a-rust \
  zdharma-continuum/z-a-as-monitor \
  zdharma-continuum/z-a-patch-dl \
  zdharma-continuum/z-a-bin-gem-node

# powerlevel10k
if command -v osascript &> /dev/null && [ ! -e "$HOME/Library/Fonts/MesloLGS NF Regular.ttf" ]; then
  curl -L 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf' >"$HOME/Library/Fonts/MesloLGS NF Regular.ttf"
  curl -L 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf' >"$HOME/Library/Fonts/MesloLGS NF Bold.ttf"
  curl -L 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf' >"$HOME/Library/Fonts/MesloLGS NF Italic.ttf"
  curl -L 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf' >"$HOME/Library/Fonts/MesloLGS NF Bold Italic.ttf"
  sleep 1
  osascript -e 'tell application "Terminal" to set the font name of default settings to "MesloLGS NF"'
fi
zinit ice depth=1; zinit light romkatv/powerlevel10k

# fzf
zinit ice lucid wait from'gh-r' as'program'
zinit light junegunn/fzf
zinit ice lucid wait
zinit snippet 'https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh'
zinit ice lucid wait as'completion'
zinit snippet 'https://raw.githubusercontent.com/b4b4r07/dotfiles/master/.zsh/Completion/_fzf'
export FZF_DEFAULT_OPTS='--cycle --height 40% --reverse --border --prompt="(^_^) ❯ "'

# asdf
zinit ice lucid as'program' src'asdf.sh'
zinit load asdf-vm/asdf

# direnv
zinit ice lucid from'gh-r' as'program' mv'direnv* -> direnv' \
      atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
      pick'direnv' src='zhook.zsh'
zinit load direnv/direnv
export DIRENV_LOG_FORMAT=
export DIRENV_WARN_TIMEOUT=1h

# History
HISTFILE="${ZDOTDIR}/.zsh_history"
HISTSIZE=10000
SAVEHIST=1000000
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history

# enable hooks
autoload -Uz add-zsh-hook

# keep awake while execution
if command -v caffeinate &> /dev/null; then
  function __be_awake () {
    sh -c 'caffeinate -u -t 86400 & echo $!' | read CAFFPID$$
  }
  function __be_ease () {
    eval CAFFPID='$CAFFPID'$$
    if [ "$CAFFPID" != "" ]; then
      if pgrep -f caffeinate | grep $CAFFPID >/dev/null; then
        kill $CAFFPID
        eval CAFFPID"$$"=""
      fi
    fi
  }
  add-zsh-hook preexec __be_awake
  add-zsh-hook precmd __be_ease
  add-zsh-hook zshexit __be_ease
fi

# peep after execution
if [ -e ${HOME}/bin/peep ]; then
  function peeexec() {
    (${HOME}/bin/peep &)
  }
  add-zsh-hook precmd peeexec
fi

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
  autoload -Uz chpwd_recent_dirs cdr
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 100
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-pushd true
fi
# change latest working directory on new shell
if [ -f ${ZDOTDIR}/.chpwd-recent-dirs ]; then
  cd $(head -1 ${ZDOTDIR}/.chpwd-recent-dirs | tr -d "$'")
  [ -f ${PWD}/.envrc ] && (direnv reload &) || :
fi

# color setting
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
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# aliases
[[ "$OSTYPE" == "darwin"* ]] && alias brew='PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin brew' || :
[ -e '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' ] && alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl' || :
[ -e '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' ] && alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code' || :
alias ip='curl ipinfo.io/ip'
alias ip_lookup='echo 192.168.0.{1..254} | xargs -P256 -n1 ping -s1 -c1 -W1 | grep ttl'
# override rm if can
command -v mv_trash &> /dev/null && alias rm="mv_trash" || :
# git
alias gsta='git status'
alias glog='git log'
alias gbra='git branch'
alias gche='git checkout'
alias gadd='git add'
alias gcom='git commit'
alias gpush='git push'
alias gpull='git pull'

# correction
setopt correct
setopt correct_all
CORRECT_IGNORE='_*'
CORRECT_IGNORE_FILE='.*'
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [No/Yes/Abort/Edit]"
alias cp='nocorrect cp'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
# alias rm='nocorrect rm'
alias sudo='nocorrect sudo'

# setopt
setopt auto_cd
setopt no_auto_remove_slash
setopt interactive_comments
setopt rm_star_silent
setopt ignore_eof
setopt no_flow_control

# For Python
export PYTHONSTARTUP=${HOME}/.pythonstartup
# TODO: these snippets not working, why?
# zinit ice wait lucid as'completion' if'command -v pip &> /dev/null' id-as'pip-completion-zsh' atclone'pip completion --zsh >_pip' atpull"%atclone"
# zinit load zdharma/null
zinit ice lucid wait as'completion'
zinit snippet 'https://raw.githubusercontent.com/srijanshetty/zsh-pip-completion/master/_pip'
function __pip () {
  pip "$@"
  if [ $# -gt 0 ] && [ "$1" = "install" ]; then
    asdf reshim python
  fi
}
alias pip='__pip'
function __venv () {
  [ ! "$VIRTUAL_ENV" ] && echo "layout python" >>${PWD}/.envrc && direnv allow || :
}
alias venv='__venv'

# completion, highlights, suggestions
zinit lucid has'docker' as'completion' is-snippet for \
  'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
  'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose'
zinit ice wait'1a' lucid atpull'zinit creinstall -q .' atload'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' blockf
zinit light zsh-users/zsh-completions
zinit ice wait'1b' lucid blockf
zinit light Aloxaf/fzf-tab
zinit wait'1c' lucid light-mode for \
  zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions

# To customize prompt, run `p10k configure` or edit ~/.zsh/.p10k.zsh.
[[ ! -f ${HOME}/.zsh/.p10k.zsh ]] || source ${HOME}/.zsh/.p10k.zsh
