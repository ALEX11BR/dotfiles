# ALEX11BR's dotfiles
![BSPWM Screenshot](https://i.redd.it/ltzegl0ewrk71.png)
Here I store my dotfiles as a Linux TWM user. I like BSPWM the most, but I also tried other WM's and have configurations thereof.

## Installation scripts
I made some installation scripts for various distros:
- `secp.sh` for Arch (requires choosing from one of the available DE's/WM's)
- `vecp.sh` for Void (optionally pass `bspwm` as the first argument to install it + various utilities)
- `fecp.sh` for Fedora (same thing as above)
- `usecp.sh` for Ubuntu & friends (same thing as above)
- `osecp.sh` for OpenSUSE Tumbleweed

Most of them are attended installation scripts, and require confirming package manager prompts (Fedora's script is an exception, as their package manager's prompts default to no as an answer).

They usually install Brave, VSCode, nVidia drivers, zsh with plugins, other useful stuff, set up the environment the way I like it.

*Why these names?* I used to store these dotfiles on a thumb drive under a folder called `secp` (I can't remember why). I decided to add a script to replicate the Arch setup I had and loved, and called it after the folder. Then, I distrohopped some more, and wanted to do the same thing for some various distros, and decided to name these scripts after the initial `secp` thing, but with the first letter borrowed from the distro name.

`cpconf` is a bash script that handles the common logic of configuring the system the way I like it. It has various command line flags described in the file.

## Windows configuration script
`wecp.cmd` and the scripts in `windows` are for configuring a Windows (11, probably 10 too) system with a bunch of stuff.
