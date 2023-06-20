{ config, pkgs, ... }:

{
  # Import hardware specific configuration
  imports = [ ./hardware-configuration.nix ];

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Secure boot
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

  # Network manager
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Europe/Zurich";

  # Sound
  sound.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # AppArmor
  security.apparmor.enable = true;

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
  nix.gc.automatic = true;

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
  programs.sway.enable = true;
  xdg.portal.wlr.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.GTK_THEME = "Adwaita:dark";

  programs = {
    # Neovim
    neovim = {
      enable = true;
      defaultEditor = true;
    };

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
