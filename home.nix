{ config, pkgs, ... }:

{
  home.username = "lena";
  home.homeDirectory = "/home/lena";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home.packages = with pkgs; [
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
    fira-mono
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
    lato
    libreoffice-fresh
    lolcat
    lutris
    mako
    moq
    mpv
    ncdu
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    nmap
    nodejs
    nodePackages.prettier
    nodePackages.svgo
    noto-fonts-cjk
    noto-fonts-emoji
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
    zeroad
    zoxide
  ];

  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Enable password manager
  programs.browserpass.enable = true;

  # Enable GPG
  services.gpg-agent.enable = true;
}
