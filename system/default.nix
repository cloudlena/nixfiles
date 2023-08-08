{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./secure-boot.nix
    ./encryption.nix
    ./sound.nix
    ./bluetooth.nix
    ./upgrade-diff.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking
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
    isNormalUser = true;
    description = "Lena";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
  };
  users.defaultUserShell = pkgs.zsh;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    home-manager
    sbctl
  ];

  programs = {
    # Window manager
    hyprland.enable = true;

    # Shell
    zsh.enable = true;

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
