{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./secure-boot.nix
  ];

  # Bootloader
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable swap on luks
  boot.initrd.luks.devices."luks-58a9f60d-bf2d-4c94-8f08-8e29a4083728".device =
    "/dev/disk/by-uuid/58a9f60d-bf2d-4c94-8f08-8e29a4083728";

  # Restrict boot mount access
  fileSystems."/boot".options = lib.mkForce [ "umask=0077" ];

  # Networking
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Europe/Zurich";

  # AppArmor
  security.apparmor.enable = true;

  # Containers
  virtualisation.podman.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

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
    hyprland.enable = true;

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
      openFirewall = true;
    };

    # Printing service
    printing = {
      enable = true;
      openFirewall = true;
      drivers = [ pkgs.brlaser ];
    };
  };

  system.stateVersion = "26.11";
}
