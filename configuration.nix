{ config, pkgs, ... }:

{
  # Import hardware specific configuration
  imports = [ ./hardware-configuration.nix ];

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable garbage collection
  nix.gc.automatic = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable AppArmor
  security.apparmor.enable = true;

  # Enable containers
  virtualisation.podman.enable = true;

  # Use secure boot with lanzaboote
  boot = {
    loader.systemd-boot.enable = pkgs.lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable network manager
  networking.networkmanager.enable = true;

  # Set time zone
  time.timeZone = "Europe/Zurich";

  # Enable sound
  sound.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.lena = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    password = "changeme";
  };
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    curl
    gcc
    git
    gnumake
    home-manager
    sbctl
    unzip
    wget
    zip
  ];

  # Enable Neovim and make it the default editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Enable ZSH
  programs.zsh.enable = true;

  # Enable process viewer
  programs.htop.enable = true;

  # Enable terminal multiplexer
  programs.tmux.enable = true;

  # Enable Steam for gaming
  programs.steam.enable = true;

  # Enable window manager
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.sway.enable = true;
  xdg.portal.wlr.enable = true;

  # Enable firmware updater
  services.fwupd.enable = true;

  # Enable power optimization
  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;

  system.stateVersion = "23.05";
}
