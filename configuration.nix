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

  # Set up user
  users.users.lena = {
    isNormalUser = true;
    description = "Lena";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      alacritty
      autotiling-rs
      awscli2
      brave
      brightnessctl
      cargo
      chafa
      chromium
      clipman
      diff-so-fancy
      dig
      fd
      fx
      fzf
      gammastep
      gh
      gimp
      gnupg
      go
      golangci-lint
      gopass
      grim
      gron
      hugo
      imv
      inkscape
      jpegoptim
      jq
      kanshi
      kubectl
      kubectx
      libreoffice-fresh
      lolcat
      lutris
      mako
      moq
      mpv
      ncdu
      nmap
      nodejs
      nodePackages.prettier
      nodePackages.svgo
      optipng
      playerctl
      poetry
      protobuf
      pwgen
      python3
      python311Packages.flake8
      quickemu
      realvnc-vnc-viewer
      ripgrep
      rnix-lsp
      rustc
      shellcheck
      shfmt
      signal-desktop
      slurp
      stern
      stow
      stylua
      swaybg
      swayidle
      swaylock
      taskwarrior
      terraform
      tflint
      timewarrior
      tldr
      tmate
      tree
      vifm
      waybar
      wf-recorder
      whois
      wine
      wl-clipboard
      wofi
      workstyle
      zathura
      zoxide
    ];
    password = "changeme";
  };
  users.defaultUserShell = pkgs.zsh;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable garbage collection
  nix.gc.automatic = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install system packages
  environment.systemPackages = with pkgs; [
    curl
    gcc
    git
    gnumake
    sbctl
    unzip
    wget
    zip
  ];

  # Install fonts
  fonts.fonts = with pkgs; [
    fira-mono
    lato
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # Enable Neovim and make it the default editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Enable password manager
  programs.browserpass.enable = true;

  # Enable ZSH
  programs.zsh.enable = true;

  # Enable GPG agent
  programs.gnupg.agent.enable = true;

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
