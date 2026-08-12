{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./secure-boot.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Pass TRIM through the LUKS layer so fstrim reaches the SSD
  boot.initrd.luks.devices."root".allowDiscards = true;

  # Networking
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Europe/Zurich";

  # Locale: Swiss formats, English language
  i18n = {
    defaultLocale = "de_CH.UTF-8";
    extraLocaleSettings.LC_MESSAGES = "en_US.UTF-8";
  };

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

  # Let PipeWire acquire realtime scheduling priority
  security.rtkit.enable = true;

  # Swap
  zramSwap.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Containers
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
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
    };

    # Smart Card service
    pcscd.enable = true;
  };

  system.stateVersion = "26.11";
}
