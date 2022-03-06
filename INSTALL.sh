#!/usr/bin/env bash
set -eu

# Const var

DOTFILES_DIR=${HOME}/.dotfiles


# Util function for installing dotfiles

function alert () {
  echo -e "\033[1;31m${1}\033[0m"
}

function install_dotfile () {
  #
  # install_dotfile .bashrc $HOME
  #   -> ln -s `${DOTFILES_DIR}/.bashrc ${HOME}/.bashrc
  #
  # install_dotfile .zsh/.zshrc $HOME
  #   -> ln -s ${DOTFILES_DIR}/.zsh/.zshrc ${HOME}/.zsh/.zshrc
  #
  local dist=${DOTFILES_DIR%/}/${1%/}
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

# start

echo "Hello, ${USER}"

# clone walkingmask/dotfiles if not exists
if [ ! -d $DOTFILES_DIR ]; then
  git clone  --recursive https://github.com/walkingmask/dotfiles.git $DOTFILES_DIR
fi

###################################################  DOTFILES SECTION  #########
echo "Install dotfiles ..."
install_dotfile .bash_profile $HOME
install_dotfile .bashrc $HOME
install_dotfile .gitconfig $HOME
install_dotfile .gitignore_global $HOME
install_dotfile .pythonstartup $HOME
install_dotfile .zsh/.p10k.zsh $HOME
install_dotfile .zsh/.zprofile $HOME
# install_dotfile .zsh/.zshenv $HOME
if [ -e ${HOME}/.zshenv -a ! -L ${HOME}/.zshenv ]; then
  mv ${HOME}/.zshenv ${HOME}/.zshenv.backup
  echo "Backed up ${HOME}/.zshenv.backup"
fi
ln -sfv ${DOTFILES_DIR%/}/.zsh/.zshenv ${HOME}/.zshenv
install_dotfile .zsh/.zshrc $HOME
alert "If some file backed up and you don't need it, delete it yourself"
echo "OK, dotfiles installed"
################################################################################

echo "Finished installation, thank you"
exit 0
