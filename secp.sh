#!/bin/bash
dirl=$(dirname $(readlink -f "$0") )
if [ "$EUID" = 0 ]; then
    echo "Treci pe utilizatorul tău, nu pe root!"
    exit
fi
grep '^\[multilib\]' /etc/pacman.conf || echo -e '[multilib]\nInclude = /etc/pacman.d/mirrorlist' | sudo tee -a /etc/pacman.conf >/dev/null
sudo pacman -Syu
sudo pacman -S git
git clone https://aur.archlinux.org/yay.git "$HOME/yay"
cd "$HOME/yay"
makepkg -sir

htoinst=""
hvalids=(amd intelnvidia)
echo "Acum alege ce profil hardware ai"
if [ -n "$1" ]; then
	htoinst="$1"
	shift
fi
while [[ ! " ${hvalids[@]} " =~ " ${htoinst} " ]];
do
	echo "(amd,intelnvidia)"
	read htoinst
done

valids=(cinnamon kde mate xfce lxqt awesome bspwm)
toinst="$1"
echo "Acum alege ce ai chef să instalezi"
while [[ ! " ${valids[@]} " =~ " ${toinst} " ]];
do
	echo "(cinnamon,kde,mate,xfce,lxqt,awesome,bspwm)"
	read toinst
done

echo "Ne apucăm de instalat un sistem cu $toinst"
cd "$dirl"
cat pbase.txt | yay -S --needed -
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable tlp
sudo systemctl enable cups

(grep '^en_US\.UTF-8 UTF-8' /etc/locale.gen > /dev/null) || (echo 'en_US.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen > /dev/null)
(grep '^ro_RO\.UTF-8 UTF-8' /etc/locale.gen > /dev/null) || (echo 'ro_RO.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen > /dev/null)
sudo cp locale.conf /etc/locale.conf

case "$htoinst" in
	"amd" ) cat pamd.txt | yay -S --needed -
	        ;;
	"intelnvidia" ) cat pinv.txt | yay -S --needed -
	                ;;
esac

case "$toinst" in
	"cinnamon" ) cat pcex.txt | yay -S --needed -
	             sudo systemctl enable lightdm
	             bash cpconf -pr -xc -p -qg -cc 'Code' -c vlc -c qalculate
	             ;;
	"mate" ) cat pmex.txt | yay -S --needed -
	         sudo systemctl enable lightdm
	         bash cpconf -pr -xc -p -qg -gb -cc 'Code' -c vlc -c qalculate
	         ;;
	"xfce" ) cat pxex.txt | yay -S --needed -
	         sudo systemctl enable lightdm
	         bash cpconf -pr -xc -p -qg -gb -cc 'Code' -c vlc -c qalculate
	         ;;
	"awesome" ) cat paex.txt | yay -S --needed -
	            sudo systemctl enable lightdm
	            bash cpconf -pr -xc -p -ct oomox-dracula -cc 'Code' -c vlc -c qalculate -c alacritty -c awesome -c sxhkd -xp -qg -pc -gb -t alacritty
	            ;;
	"bspwm" ) cat pbex.txt | yay -S --needed -
	          sudo systemctl enable lightdm
	          bash cpconf -pr -xc -p -ct oomox-dracula -cc 'Code' -c vlc -c qalculate -c bspwm -c polybar -c sxhkd -c alacritty -c rofi -xp -qg -pc -gb -t alacritty
		  ;;
	"lxqt" ) cat plxqex.txt | yay -S --needed -
	         sudo systemctl enable sddm
	         bash cpconf -pr -xc -p -cc 'Code' -c vlc -c qalculate
		 ;;
	"kde" ) cat pkdex.txt | yay -S --needed -
	        sudo systemctl enable sddm
	        bash cpconf -pr -xc -p -cc 'Code' -c vlc -c qalculate
	        ;;
esac

systemctl enable --user gcr-ssh-agent.service && echo 'export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR"/gcr/ssh' >> ~/.profile

rm -rf "$HOME/yay"
