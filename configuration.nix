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
  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "random";
  };

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
      lynis
      mako
      moq
      mpv
      ncdu
      nmap
      nodejs
      stern
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
      zeroad
      zoxide
    ];
    password = "changeme";
  };
  users.defaultUserShell = pkgs.zsh;

  fonts.fonts = with pkgs; [
    fira-mono
    lato
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

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

  # Enable system monitoring
  programs.htop.enable = true;

  # Enable password manager
  programs.browserpass.enable = true;

  # Enable KDE Connect
  programs.kdeconnect.enable = true;

  # Enable terminal multiplexer
  programs.tmux.enable = true;

  # Enable Steam for gaming
  programs.steam.enable = true;

  # Enable window manager
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.sway.enable = true;
  xdg.portal.wlr.enable = true;

  # Enable GPG agent
  programs.gnupg.agent.enable = true;

  # Enable Kubernetes
  services.k3s.enable = true;
  networking.firewall.allowedTCPPorts = [ 6643 ];

  # Enable firmware updater
  services.fwupd.enable = true;

  # Enable power optimization
  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;

  system.stateVersion = "23.05";
}
