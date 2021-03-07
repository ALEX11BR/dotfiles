#!/bin/bash
cd $(dirname $(readlink -f "$0") )
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install -y brave-browser

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install -y code

sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
pmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo rpm -ivh http://rpm.livna.org/livna-release.rpm
sudo dnf update
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda vdpauinfo libva-vdpau-driver libva-utils
sudo dnf install -y google-noto-\* vlc gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav lame\* libdvdcss
sudo dnf install -y zsh zsh-syntax-highlighting zsh-autosuggestions
sudo dnf install -y network-manager-applet neovim git
bash cpconf -v "/etc/vimrc.local" -f "50-families.conf" -xp -n -z "/etc/zshrc" -zs "s;/zsh/plugins;;" -c i3 -c alacritty -c awesome -c qtile -c bspwm -c sxhkd -c termite -c polybar
