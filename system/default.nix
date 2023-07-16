{ pkgs, ... }:

{
  # Import hardware specific configuration
  imports = [
    ./hardware-configuration.nix
    ./secure-boot.nix
    ./encryption.nix
    ./sound.nix
  ];

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Network manager
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Europe/Zurich";

  # AppArmor
  security.apparmor.enable = true;

  # Temporary fix for Swaylock issue
  security.pam.services.swaylock = { };

  # Containers
  virtualisation.podman.enable = true;

  # Users
  users.users.lena = {
    description = "Lena";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    password = "changeme";
  };
  users.defaultUserShell = pkgs.zsh;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    curl
    gcc
    gnumake
    home-manager
    sbctl
    unzip
    wget
    zip
  ];

  # Window manager
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs = {
    # ZSH
    zsh.enable = true;

    # Git
    git.enable = true;

    # Process viewer
    htop.enable = true;

    # Terminal multiplexer
    tmux.enable = true;

    # Gaming
    steam.enable = true;
  };

  services = {
    # Firmware updater
    fwupd.enable = true;

    # Geolocation service
    geoclue2.enable = true;

    # Power optimization
    auto-cpufreq.enable = true;
    thermald.enable = true;
  };

  system.stateVersion = "23.05";
}
