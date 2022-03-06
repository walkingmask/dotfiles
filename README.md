# dotfiles


## Pre-install

macOS

```
xcode-select --install
# https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

WSL2

```
# Install fonts
https://github.com/romkatv/powerlevel10k#manual-font-installation
https://qiita.com/peachft/items/0d8161102e2b07248467#フォントの変更
sudo apt-get install build-essential curl file git
# https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/${USER}/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
which zsh | sudo tee -a /etc/shells
chsh -s `which zsh`
```


## Install

```
bash -c "$(curl https://raw.githubusercontent.com/walkingmask/dotfiles/master/INSTALL.sh)"
```


## Update

```
cd ${HOME}/.dotfiles && git pull --rebase
```


## Update origin

```
cd ${HOME}/.dotfiles
git commit -am "Update"
git push
```


## References

* Inspired by [b4b4r07/dotfiles](https://github.com/b4b4r07/dotfiles)
* Referenced [Code-Hex/dotfiles](https://github.com/Code-Hex/dotfiles)
