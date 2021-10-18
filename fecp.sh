#!/bin/bash
cd $(dirname $(readlink -f "$0") )
if [ "$EUID" = 0 ]; then
    echo "Treci pe utilizatorul tău, nu pe root!"
    exit
fi
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install -y brave-browser

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install -y code

sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo rpm -ivh http://rpm.livna.org/livna-release.rpm
sudo dnf update -y
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda vdpauinfo libva-vdpau-driver libva-utils
sudo dnf install -y flatpak google-noto-\* vlc gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav lame\* libdvdcss playerctl sxhkd python3-pyusb
sudo dnf install -y zsh zsh-syntax-highlighting zsh-autosuggestions fontawesome5-fonts-all
sudo dnf install -y neovim git htop
sudo dnf install -y alacritty
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
echo "fastestmirror=1" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
bash cpconf -v "/etc/vimrc.local" -f "50-families.conf" -n -xc -pi -z "/etc/zshrc" -zs "s;/zsh/plugins;;" -ct oomox-dracula -c i3 -c alacritty -c awesome -c qtile -c bspwm -c sxhkd -c rofi -c polybar -t alacritty
if [ "$1" = "bspwm" ]; then
	sudo dnf install bspwm polybar rofi picom xsettingsd gnome-keyring udiskie parcellite blueman xfce4-notifyd maim file-roller numlockx network-manager-applet picom udiskie dnfdragora-updater
fi
sed "s/pamac-tray/dnfdragora-updater/" xprofile | sudo tee /etc/xprofile >/dev/null
