# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

let
  # Import unstable Nixpkgs with an overlay
  unstablePkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/refs/heads/nixos-unstable.tar.gz";
    sha256 = "1l7wzwwlx1h0946l31apb939scb7xmcyywgs1jng7lzns49ca2cd";
  }) {
    overlays = [ (final: prev: {
      # Overlay customizations go here
    }) ];
  };

  # Define the overlay for the main nixpkgs
  overlay = final: prev: {
    # Overlay customizations go here
  };

in {
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Apply the overlay
  nixpkgs.overlays = [
    overlay
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.pulseaudio.enable = false;
  services.libinput.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # User config

  users.users.jesse = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC99p82DXKFQ8fRGQQ2Yy/WaRkBWz4HbI0ymXochHDyrQ09AhP+/HnGYh1hNKg3jfC5LQ7zRDbocn3mmD1WKVu4AJMU2eCpDJNCjO1H6CXPhLusdVD1N2i61dGqwO/9cf2PhAkgrEjaQD1hWZ9T4Joy95/I/88czVWDQdJPj/SNIF9er/n7zfa7IIRkXrZLwuANg9cfZ8CDEL8eRSWqhX0HX5aLmdz1tvqx/KDD9dSAECiceg6TTPwWWJv9P3bvuaKK8qwQ5R3McWHSDvuuCIE7vp/iz7xSHYhMxc98jwtZDLw1tlFGo1E4X8K6I+0O0PNHDdlkXt/5Ph4B1V/g8F2C/Uc8CTOM6gjqgESjV5SpUZjnSH8ByOp8C+wi56ChKdqZN+m5g8ej0wR0gTwu70+PkMznH/3XHwvX9gT3MH2bIB0jbMim0gT9XeVPTiMfMr1yJr11tiqRvFe72tEw3fmY8y8GmEZp7Ga68sQTmXe1LpJ8XY8LPhgwbk0EN4vBlik= jesse@DESKTOP-50J98N6"
    ];
  };

  environment.systemPackages = with pkgs; [
    # Editors
    pkgs.vscode
    pkgs.vim

    # Hyprland
    pkgs.wofi
    pkgs.swww
    pkgs.mako
    pkgs.btop
    pkgs.swaylock-effects
    pkgs.wofi
    pkgs.wlogout
    pkgs.swappy
    pkgs.grim
    pkgs.slurp
    pkgs.mpv
    pkgs.brightnessctl
    pkgs.networkmanagerapplet
    pkgs.gnome.file-roller
    pkgs.starship
    pkgs.papirus-icon-theme
    pkgs.noto-fonts-emoji-blob-bin
    pkgs.lxappearance
    pkgs.xfce.xfce4-settings
  
    # Themes
    pkgs.adwaita-icon-theme 

    # Thunar
    pkgs.xfce.thunar
    pkgs.unzip
    pkgs.zip
    pkgs.gvfs
    pkgs.xfce.thunar-archive-plugin

    # Bluetooth
    pkgs.bluez
    pkgs.blueman
    
    # PulseAudio
    pkgs.pamixer
    pkgs.pavucontrol 

    # Linux Needed
    pkgs.wget
    pkgs.neofetch
    pkgs.git
    pkgs.htop
    pkgs.kitty
    pkgs.wireguard-tools
    pkgs.gnome.gnome-keyring

    # User Packages
    pkgs.firefox
    pkgs.discord
    pkgs.steam
    pkgs.thunderbird
    pkgs.github-desktop
    pkgs.mysql-workbench
    pkgs.remmina
    pkgs.powershell

    # Litris
    (lutris.override {
      extraLibraries =  pkgs: [
        # List library dependencies here
      ];
    })
    (lutris.override {
       extraPkgs = pkgs: [
         # List package dependencies here
       ];
    })


    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
  ];
  
  # org.freedesktp.secrets
  # services.passSecretService.enable = true;
 
  fonts.fontconfig.enable = true;
  networking.wg-quick.interfaces.wg0.configFile = "/etc/wireguard/wg0.conf";
  services.openssh.enable = true;
  networking.firewall.enable = false;
  
  environment.variables = {
    GTK_THEME = "Adwaita-dark";
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = false;
    displayManager.gdm.wayland = true;
    videoDrivers = [ "nvidia" ];
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    TERM = "xterm-256color";
  };

  hardware = {
    graphics.enable = true;
  };

  # Program Configs
  programs.steam.enable=true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Home Manager configuration for the user "jesse"
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.jesse = import ./home.nix;


  system.stateVersion = "24.05";
}


