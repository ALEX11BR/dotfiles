# Popa Ioan-Alexandru dotfiles - https://github.com/alex11br/dotfiles

{ config, pkgs, ... }:

{
  networking.hostName = "alex-pc";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
}
