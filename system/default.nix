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
    alsa.enable = true;
  };

  # Let PipeWire acquire realtime scheduling priority
  security.rtkit.enable = true;

  # Let Swaylock authenticate. programs.mango does not pull in Nixpkgs'
  # wayland-session module the way programs.hyprland did, so the PAM service it
  # used to provide has to be requested explicitly.
  security.pam.services.swaylock = { };

  # Default font packages, also lost with wayland-session
  fonts.enableDefaultPackages = true;

  # Screen sharing. programs.mango installs xdg-desktop-portal-wlr but leaves it
  # unconfigured, so it hunts for an output chooser on PATH, finds none and
  # fails with "no output found". Point it at Slurp, which lets the monitor to
  # share be picked by clicking it.
  xdg.portal.wlr = {
    enable = true;
    settings.screencast = {
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
    };
  };

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

  services.getty.autologinUser = "lena";

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs = {
    # Shell
    zsh.enable = true;

    # Window manager
    mango.enable = true;

    # X11 applications. Also from wayland-session, and Mango is unwrapped, so
    # wlroots only finds Xwayland if it is on the system PATH.
    xwayland.enable = true;

    # Settings store GTK apps and Home Manager write theme settings into
    dconf.enable = true;

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
