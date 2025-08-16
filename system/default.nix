{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./secure-boot.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Set up keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-58a9f60d-bf2d-4c94-8f08-8e29a4083728".device =
    "/dev/disk/by-uuid/58a9f60d-bf2d-4c94-8f08-8e29a4083728";
  boot.initrd.luks.devices."luks-58a9f60d-bf2d-4c94-8f08-8e29a4083728".keyFile =
    "/crypto_keyfile.bin";

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

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

  programs = {
    # Shell
    zsh.enable = true;

    # Window manager
    hyprland.enable = true;

    # Gaming
    steam.enable = true;
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
  };

  system.stateVersion = "25.11";
}
