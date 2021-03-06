# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
    ];
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.timeout = null;

  networking.hostName = "laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # networking.interfaces.eno1.useDHCP = true;
  # networking.interfaces.wlo1.useDHCP = true;
  networking.networkmanager.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "ro_RO.UTF-8";
      LC_PAPER = "ro_RO.UTF-8";
      LC_NUMERIC = "ro_RO.UTF-8";
      LC_MEASUREMENT = "ro_RO.UTF-8";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "ro";
  };

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (neovim.override{
      vimAlias = true;
      configure = {
        packages.myplugins = with pkgs.vimPlugins; {
          start = [ vim-nix vim-airline ];
          opt = [];
        };
        customRC = builtins.readFile ./vimrc;
      };
    })
    (chromium.override {
      commandLineArgs = "--load-media-router-component-extension=1";
      enableWideVine = true;
      enableVaapi = true;
    })
    wget openssh git
    gcc
    starship # zsh-powerlevel10k
    nvidia-offload
    rofi gmrun termite neofetch maim networkmanagerapplet numlockx xorg.xbacklight
    gnome3.gnome-calculator
    polybar
    xfce.thunar xfce.thunar-volman xfce.xfconf xfce.tumbler xfce.thunar-archive-plugin gnome3.file-roller
    gtk-engine-murrine gtk_engines gnome-themes-standard libsForQt5.qtstyleplugins lxappearance
    breeze-icons sierra-gtk-theme #mate.mate-themes
    libreoffice vlc vscode gimp inkscape qbittorrent
    openttd discord
  ];
  virtualisation.virtualbox.host = {
    enable = true;
    # enableExtensionPack = true;
  };
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    (nerdfonts.override {
      fonts = [ "SourceCodePro" ];
    })
  ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Noto Sans" "emoji" ];
    serif = [ "Noto Serif" ];
    monospace = [ "SauceCodePro Nerd Font Mono" ];
  };
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    shellInit = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

      bindkey '^[Oc' forward-word
      bindkey '^[Od' backward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
    '';
    promptInit = ''
      eval "$(starship init zsh)"
    '';
  };
  hardware.openrazer.enable = true;
  qt5.platformTheme = "gtk2";
  services.gvfs.enable = true;
  programs.dconf.enable = true;
  gtk.iconCache.enable = true;
  environment.variables = {
    TERMINAL = "termite";
    QT_QPA_PLATFORMTHEME = "gtk2";
  };
  security.sudo.wheelNeedsPassword = false;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "ro";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      tappingDragLock = false;
      naturalScrolling = true;
    };
  };
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver vaapiIntel vaapiVdpau libvdpau-va-gl
    ];
  };
  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.lightdm = {
    enable = true;
    extraSeatDefaults = ''
      greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
    '';
  };
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.xfce = {
  #   enable = true;
  #   enableXfwm = false;
  # };
  # services.xserver.desktopManager.gnome3.enable = true;
  # services.xserver.desktopManager.mate.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  # services.xserver.windowManager.i3 = {
  #   enable = true;
  #   package = pkgs.i3-gaps;
  #   extraPackages = with pkgs; [
  #     i3status
  #   ];
  # };
  services.picom = {
    enable = true;
    backend = "glx";
    inactiveOpacity = 0.8;
    vSync = true;
  };
  services.fstrim.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "vboxusers" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  home-manager.users.alex = {
    programs.git = {
      enable = true;
      userName = "Popa Ioan Alexandru";
      userEmail = "alexioanpopa11@gmail.com";
    };

    programs.chromium = {
      enable = true;
      extensions = [
        "occjjkgifpmdgodlplnacmkejpdionan" # autoscroll
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      ];
    };

    gtk = {
      enable = true;
      iconTheme.name = "breeze";
      theme.name = "Sierra-light-solid";
    };

    xdg.configFile."termite/config".text = builtins.readFile termite/config;
    xdg.configFile."polybar/config".text = builtins.readFile polybar/config;
    xdg.configFile."polybar/launch.sh".text = builtins.readFile polybar/launch.sh;
    xdg.configFile."polybar/launch.sh".executable = true;
    xdg.configFile."bspwm/bspwmrc".text = builtins.readFile bspwm/bspwmrc;
    xdg.configFile."bspwm/bspwmrc".executable = true;
    xdg.configFile."sxhkd/sxhkdrc".text = builtins.readFile sxhkd/sxhkdrc;

    services.udiskie.enable = true;

    services.parcellite.enable = true;

    services.network-manager-applet.enable = true;

    services.blueman-applet.enable = true;
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.03"; # Did you read the comment?

}

