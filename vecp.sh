#!/bin/bash
cd $(dirname $(readlink -f "$0") )
if [ "$EUID" = 0 ]; then
    echo "Treci pe utilizatorul tău, nu pe root!"
    exit
fi
sudo xbps-install -Suf
sudo xbps-install -Suf void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree
sudo xbps-install -Suf NetworkManager sxhkd playerctl htop zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions lightdm lightdm-gtk3-greeter qt5-styleplugins gnome-themes-extra breeze-icons mesa-dri network-manager-applet alacritty qbittorrent gvim git unrar p7zip xdg-user-dirs-gtk gvfs-mtp parcellite picom octoxbps gst-libav gst-plugins-bad1 gst-plugins-good1 gst-plugins-ugly1 cups hplip nvidia nvidia-libs-32bit intel-video-accel xorg-minimal elogind pulseaudio alsa-plugins-pulseaudio bluez blueman acpilight font-awesome noto-fonts-ttf noto-fonts-emoji noto-fonts-cjk libreoffice chromium
if [ "$1" = "bspwm" ]; then
	sudo xbps-install -Suf bspwm polybar rofi udiskie xfce4-notifyd maim file-roller pcmanfm-qt lxappearance
fi
bash cpconf -v "/etc/vimrc.local" -xp -qg -pc -ct oomox-dracula -c bspwm -c sxhkd -c polybar -c rofi -c alacritty -t alacritty
sed "s/pamac-tray/octoxbps-notifier/" /etc/xprofile | sudo tee /etc/xprofile >/dev/null
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/launch.sh
sudo rm /var/service/dhcpcd
sudo rm /var/service/lxdm
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/cupsd /var/service
sudo ln -s /etc/sv/bluetoothd /var/service
sudo ln -s /etc/sv/lightdm /var/service
