#!/bin/bash
dirl=$(dirname $(readlink -f "$0") )
echo "Avem utilizatorul bun (alex) sper, hai să ne apucăm de treabă!"
sudo pacman -S git
git clone https://aur.archlinux.org/yay.git "$HOME/yay"
cd "$HOME/yay"
makepkg -sir
valids=(cinnamon kde mate xfce lxqt awesome bspwm)
toinst=nu
echo "Acum alege ce ai chef să instalezi"
while [[ ! " ${valids[@]} " =~ " ${toinst} " ]];
do
	echo "(cinnamon,kde,mate,xfce,lxqt,awesome,bspwm)"
	read toinst
done
echo "Ne apucăm de instalat un sistem cu $toinst"
cd $dirl
cat pbase.txt | yay -S --needed -
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable org.cups.cupsd.service

case "$toinst" in
	"cinnamon" ) cat pcex.txt | yay -S --needed -
	             sudo systemctl enable lightdm
	             bash cpconf -qg
	             ;;
	"mate" ) cat pmex.txt | yay -S --needed -
	         yay -Rs mate-calc
	         sudo systemctl enable lightdm
	         bash cpconf -qg
	         ;;
	"xfce" ) cat pxex.txt | yay -S --needed -
	         yay -Rs parole orage
	         sudo systemctl enable lightdm
	         bash cpconf -qg
	         ;;
	"awesome" ) cat paex.txt | yay -S --needed -
	            sudo systemctl enable lightdm
	            bash cpconf -c termite -c awesome -xp -qg -pc -t termite
	            ;;
	"bspwm" ) cat pbex.txt | yay -S --needed -
	          sudo systemctl enable lightdm
	          bash cpconf -c bspwm -c polybar -c sxhkd -c termite -xp -qg -pc -t termite
		  ;;
	"lxqt" ) cat plxqex.txt | yay -S --needed -
	         sudo systemctl enable sddm
	         bash cpconf
		 ;;
	"kde" ) cat pkdex.txt | yay -S --needed -
	        sudo systemctl enable sddm
	        bash cpconf
	        ;;
esac