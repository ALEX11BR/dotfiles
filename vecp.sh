#!/bin/bash
cd $(dirname $(readlink -f "$0") )
if [ "$EUID" = 0 ]; then
    echo "Treci pe utilizatorul tău, nu pe root!"
    exit
fi
sudo xbps-install -Suf
sudo xbps-install -Suf void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree
sudo xbps-install -Suf NetworkManager sxhkd xclip playerctl numlockx htop wget zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions lightdm lightdm-gtk3-greeter qt5-styleplugins gnome-themes-extra breeze-icons mesa-dri xss-lock xsecurelock network-manager-applet wmname alacritty gmrun qbittorrent upower gvim git unrar p7zip xdg-user-dirs-gtk gvfs-mtp parcellite picom octoxbps gst-libav gst-plugins-bad1 gst-plugins-good1 gst-plugins-ugly1 yt-dlp cups hplip ntfs-3g nvidia nvidia-libs-32bit intel-video-accel xorg-minimal elogind pulseaudio alsa-plugins-pulseaudio bluez blueman acpilight dejavu-fonts-ttf noto-fonts-ttf noto-fonts-emoji noto-fonts-cjk libreoffice chromium
if [ "$1" = "bspwm" ]; then
	sudo xbps-install -Suf bspwm polybar rofi udiskie xfce4-notifyd maim xsettingsd gnome-keyring file-roller pcmanfm-qt
fi
bash cpconf -v "/etc/vimrc.local" -xs "s/pamac-tray/octoxbps-notifier/" -ni -qg -pi -pc -gb -ct oomox-dracula -cc 'Code - OSS' -c bspwm -c sxhkd -c polybar -c rofi -c alacritty -t alacritty
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/launch.sh
sudo rm /var/service/dhcpcd
sudo rm /var/service/lxdm
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/cupsd /var/service
sudo ln -s /etc/sv/bluetoothd /var/service
sudo ln -s /etc/sv/lightdm /var/service
