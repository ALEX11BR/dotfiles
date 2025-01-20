#!/bin/bash
cd $(dirname $(readlink -f "$0") )
if [ "$EUID" = 0 ]; then
	echo "Treci pe utilizatorul tău, nu pe root!"
	exit
fi
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

sudo apt-get install zsh zsh-autosuggestions zsh-syntax-highlighting git neovim yt-dlp fonts-noto sxhkd numlockx xclip htop qalculate-gtk vlc vlc-plugin-fluidsynth unrar libdvdcss2 gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav python3-usb python-is-python3
sudo apt-get install latexmk texlive-base texlive-bibtex-extra texlive-binaries texlive-fonts-extra texlive-fonts-recommended texlive-font-utils texlive-formats-extra texlive-games texlive-humanities texlive-latex-extra texlive-latex-recommended texlive-luatex texlive-science texlive-metapost texlive-music texlive-pictures texlive-plain-generic texlive-pstricks texlive-publishers texlive-xetex texlive-lang-english texlive-lang-european

if [ "$1" = "bspwm" ]; then
	sudo apt-get install bspwm polybar picom parcellite gmrun alacritty maim suckless-tools xss-lock xsecurelock udiskie rofi network-manager-gnome blueman notification-daemon xsettingsd gnome-keyring
fi

bash cpconf -xc -ni -pi -v "/etc/vim/vimrc.local" -ps "s/wheel/sudo/g" -zs "s;/zsh/plugins;;" -ct oomox-dracula -n -f "50-families.conf" -cc Code -c qalculate -c i3 -c awesome -c qtile -c bspwm -c polybar -c sxhkd -c rofi -c kitty -c alacritty -pc -xp -xs "/^pamac-tray \\&/d;s|xfce4/notifyd/xfce4-notifyd|notification-daemon/notification-daemon|" -t alacritty
echo '[Do anything you want]
Identity=unix-group:sudo
Action=*
ResultActive=yes' | sudo tee /var/lib/polkit-1/localauthority/50-local.d/disable-passwords.pkla >/dev/null
sudo dpkg-reconfigure libdvd-pkg
