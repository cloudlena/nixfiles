{ config, pkgs, ... }:

{
  # Import hardware specific configuration
  imports = [ ./hardware-configuration.nix ];

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Use secure boot with lanzaboote
  boot = {
    loader.systemd-boot.enable = pkgs.lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Set up keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-58a9f60d-bf2d-4c94-8f08-8e29a4083728".device = "/dev/disk/by-uuid/58a9f60d-bf2d-4c94-8f08-8e29a4083728";
  boot.initrd.luks.devices."luks-58a9f60d-bf2d-4c94-8f08-8e29a4083728".keyFile = "/crypto_keyfile.bin";

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

  # Enable AppArmor
  security.apparmor.enable = true;

  # Enable containers
  virtualisation.podman.enable = true;

  users.users.lena = {
    isNormalUser = true;
    description = "Lena";
    extraGroups = [ "wheel" "networkmanager" ];
    password = "changeme";
  };
  users.defaultUserShell = pkgs.zsh;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable garbage collection
  nix.gc.automatic = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
