#!/usr/bin/env bash
set -eu

echo "Hello, ${USER}"

if [[ ! "$OSTYPE" =~ ^darwin ]]; then
  echo "INSTALL.sh only supports macOS now"
  echo "Bye!"
  exit 1
fi

# clone walkingmask/dotfiles if not exists, and update
if [ ! -d ${HOME}/.dotfiles ]; then
  git clone  --recursive https://github.com/walkingmask/dotfiles.git ${HOME}/.dotfiles
fi
cd ${HOME}/.dotfiles
git pull --rebase false

# Util function for installing dotfiles
function alert () {
  echo -e "\033[1;31m${1}\033[0m"
}
HERE=$(cd $(dirname $0); pwd)
function install_dotfile () {
  #
  # install_dotfile .bashrc $HOME
  #   -> ln -s ${HERE}/.bashrc $HOME/.bashrc
  #
  # install_dotfile .zsh/.zshrc $HOME
  #   -> ln -s ${HERE}/.zsh/.zshrc $HOME/.zsh/.zshrc
  #
  local dist=${HERE%/}/${1%/}
  local target=${2%/}/${1%/}
  local parents=$(dirname ${target})
  if [ ! -e $parents ]; then
    mkdir -p $parents
    echo "Created ${parents}"
  fi
  if [ -e $target -a ! -L $target ]; then
    mv $target ${target}.backup
    alert "Backed up ${target}.backup"
  fi
  ln -sfnv $dist $target
}

echo "Install dotfiles ..."
###################################################  DOTFILES SECTION  #########
install_dotfile .bash_profile $HOME
install_dotfile .bashrc $HOME
install_dotfile .config/notes/config.sh $HOME
install_dotfile .gitconfig $HOME
install_dotfile .gitignore_global $HOME
install_dotfile .pythonstartup $HOME
install_dotfile .tool-versions $HOME
install_dotfile .zsh/.p10k.zsh $HOME
install_dotfile .zsh/.zprofile $HOME
# install_dotfile .zsh/.zshenv $HOME
if [ -e ${HOME}/.zshenv -a ! -L ${HOME}/.zshenv ]; then
  mv ${HOME}/.zshenv ${HOME}/.zshenv.backup
  echo "Backed up ${HOME}/.zshenv.backup"
 fi
ln -sfv ${HERE%/}/.zsh/.zshenv ${HOME}/.zshenv
install_dotfile .zsh/.zshrc $HOME
################################################################################
alert "If some file backed up and you don't need it, delete it yourself"
echo "OK, dotfiles installed"

echo "Install Homebrew..."
if command -v brew >/dev/null; then
  echo "Homebrew already exists"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "OK, Homebrew installed"
fi

echo "Install asdf..."
# Installing asdf and its dependencies is complicated, so using Homebrew
if command -v asdf >/dev/null; then
  echo "asdf already exists"
else
  brew install asdf
  echo "OK, asdf installed"
fi

echo "Install asdf plugins..."
source $(brew --prefix asdf)/asdf.sh
if [ -f ${HOME}/.tool-versions ]; then
  echo "global .tool-versions found"
  asdf install
  echo "OK, asdf plugins installed"
else
  echo "No global .tool-versions found"
  asdf plugin add python
  python_latest=$(asdf latest python)
  asdf install python $python_latest
  asdf global python $python_latest system
  echo "Only latest python plugin was installed"
fi

echo "Install ~/bin"
sh ${HERE}/src/install.sh
echo "OK, ~/bin installed"

echo "Finished installation, thank you"
exit 0
