{ config, pkgs, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix
    ];
  
  boot.kernelPackages = pkgs.linuxPackages_zen; 

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

    hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };  

  services.blueman.enable = true;

  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.shellAliases = {
    nse = "sudo nano /etc/nixos/configuration.nix";
    nsc = "sudo nixos-rebuild switch";
    nhf = "sudo nixos-rebuild switch --flake ~/naos#asus";
  };

    programs.hyprland = {
    enable = true;
    xwayland.enable = false;
  };

  #nvidia
   hardware.graphics = {
    enable = true;
   };
  
   services.xserver.videoDrivers = ["nvidia"];

   hardware.nvidia = {

   modesetting.enable = true;
   powerManagement.enable = false;
   powerManagement.finegrained = false;
   open = false;
   nvidiaSettings = true;
   package = config.boot.kernelPackages.nvidiaPackages.stable;
 
 };

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "tr_TR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  services.displayManager.sddm.wayland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "tr";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "trq";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr ];
   };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
   };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.asus = {
    isNormalUser = true;
    description = "asus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  microsoft-edge
  peazip
  onlyoffice-desktopeditors
  slurp
  wl-clipboard
  xdg-desktop-portal-hyprland
  kitty
  zsh
  starship
  pavucontrol
  brightnessctl
  playerctl
  freshfetch
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-emoji
  font-awesome 
  catppuccin-gtk
  papirus-icon-theme 
  code-cursor
  spicetify-cli
  spotify
  system-config-printer
  inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  system.stateVersion = "25.05";

}
