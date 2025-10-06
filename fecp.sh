#!/bin/bash
cd $(dirname $(readlink -f "$0") )
if [ "$EUID" = 0 ]; then
    echo "Treci pe utilizatorul tău, nu pe root!"
    exit
fi
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf install -y brave-browser

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install -y code

sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y rpmfusion-free-release-tainted
sudo dnf update -y
if [ "$1" = "amd" ]; then
	sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
	sudo dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
	sudo dnf swap -y mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
	sudo dnf swap -y mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
	shift
else
	sudo dnf install -y  akmod-nvidia xorg-x11-drv-nvidia-cuda vdpauinfo libva-vdpau-driver libva-utils
fi
sudo dnf install -y flatpak google-noto-\* vlc gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav lame\* libdvdcss unrar playerctl texlive-scheme-medium xclip qalculate-gtk sxhkd python3-pyusb
sudo dnf install -y zsh zsh-syntax-highlighting zsh-autosuggestions
sudo dnf install -y neovim git htop wget upower yt-dlp
sudo dnf install -y alacritty
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
echo "fastestmirror=1" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo mkdir -p /etc/X11/xinit/xinitrc.d/
echo -e '#!/bin/sh\n[ -f /etc/xprofile ] && . /etc/xprofile' | sudo tee /etc/X11/xinit/xinitrc.d/60-profile.sh >/dev/null

if [ "$1" = "kde" ]; then
	cat >> "$HOME/.profile" <<EOF
export SSH_ASKPASS=/usr/bin/ksshaskpass
export SSH_ASKPASS_REQUIRE=prefer
EOF
	shift
else
	sudo dnf install -y gcr
	systemctl enable --user gcr-ssh-agent.service && echo 'export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR"/gcr/ssh' >> ~/.profile
fi

bash cpconf -v "/etc/vimrc.local" -f "50-families.conf" -ni -n -xc -pi -pc -pr -xs "s/pamac-tray/dnfdragora-updater/;s|/usr/lib/xfce4/notifyd/xfce4-notifyd|/usr/lib64/xfce4/notifyd/xfce4-notifyd|" -z "/etc/zshrc" -zs "s;/zsh/plugins;;" -ct oomox-dracula -cc Code -c qalculate -c i3 -c alacritty -c awesome -c qtile -c bspwm -c sxhkd -c rofi -c polybar -t alacritty
if [ "$1" = "bspwm" ]; then
	sudo dnf install -y bspwm polybar rofi rofimoji picom xsettingsd wmname xss-lock xsecurelock gnome-keyring parcellite blueman xfce4-notifyd feh maim file-roller numlockx network-manager-applet udiskie dnfdragora-updater
fi
