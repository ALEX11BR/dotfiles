#!/bin/bash
cd $(dirname $(readlink -f "$0") )

sudo zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
sudo zypper refresh
sudo zypper install x11-video-nvidiaG05 nvidia-glG05

echo "### Installing vlc ###"
echo "* When prompted to solve some conflicts, choose first option 2, then option 1 a few times"
sudo zypper ar -cfp 90 -n VLC http://download.videolan.org/pub/vlc/SuSE/Tumbleweed/ vlc
sudo zypper refresh
sudo zypper install vlc vlc-codecs
sudo zypper dup --from vlc --allow-vendor-change

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
sudo zypper refresh
sudo zypper install code

sudo zypper install git zsh gvim noto-\*fonts

sudo zypper addrepo https://download.opensuse.org/repositories/shells:zsh-users:zsh-syntax-highlighting/openSUSE_Tumbleweed/shells:zsh-users:zsh-syntax-highlighting.repo
sudo zypper refresh
sudo zypper install zsh-syntax-highlighting

sudo zypper addrepo https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/openSUSE_Tumbleweed/shells:zsh-users:zsh-autosuggestions.repo
sudo zypper refresh
sudo zypper install zsh-autosuggestions

bash cpconf -v "/etc/vimrc" -z "/etc/zsh.zshrc.local" -zs "s;/zsh/plugins;;" -f "50-families.conf"

