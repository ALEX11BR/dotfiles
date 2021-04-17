#!/bin/bash
cd $(dirname $(readlink -f "$0") )
sudo apt install apt-transport-https curl
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install code
rm packages.microsoft.gpg

sudo apt-get install zsh zsh-autosuggestions zsh-syntax-highlighting git neovim fonts-noto vlc vlc-plugin-fluidsynth libdvdcss2 gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav

bash cpconf -v "/etc/vim/vimrc.local" -ps "s/wheel/sudo/g" -zs "s;/zsh/plugins;;" -n -f "50-families.conf"
echo '[Do anything you want]
Identity=unix-group:sudo
Action=*
ResultActive=yes' | sudo tee  /var/lib/polkit-1/localauthority/50-local.d/disable-passwords.pkla >/dev/null
sudo dpkg-reconfigure libdvd-pkg

