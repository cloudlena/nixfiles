{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./secure-boot.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Europe/Zurich";

  # Printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };

  # Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Swap
  zramSwap.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # AppArmor
  security.apparmor.enable = true;

  # Containers
  virtualisation.podman.enable = true;

  # Users
  users.users.lena = {
    isNormalUser = true;
    description = "Lena";
    extraGroups = [
      "wheel"
      "networkmanager"
      "dialout"
    ];
    initialPassword = "changeme";
  };
  users.defaultUserShell = pkgs.zsh;

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs = {
    # Shell
    zsh.enable = true;

    # Window manager
    mangowc.enable = true;

    # Gaming
    steam.enable = true;

    # Nix store garbage collection
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 14d";
      };
    };
  };

  services = {
    # Firmware updater
    fwupd.enable = true;

    # Geolocation service
    geoclue2.enable = true;

    # mDNS service
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };

  system.stateVersion = "26.11";
}
