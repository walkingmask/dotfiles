# Locale
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# ZDOTDIR
export ZDOTDIR="${HOME}/.zsh"
if [ ! -f ${ZDOTDIR}/.zshenv ]; then
  ln -fs ${HOME}/.zshenv ${ZDOTDIR}/.zshenv
fi

# ~/bin
if [ -d "${HOME}/bin" ]; then
  export PATH="${HOME}/bin:$PATH"
fi