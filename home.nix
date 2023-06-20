{ config, pkgs, ... }:

{
  home.username = "lena";
  home.homeDirectory = "/home/lena";

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
    gammastep
    gh
    gimp
    golangci-lint
    gopass
    grim
    gron
    hugo
    imv
    inkscape
    jpegoptim
    kanshi
    kubectl
    kubectx
    lato
    libreoffice-fresh
    lolcat
    lutris
    moq
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
    rnix-lsp
    rustc
    shellcheck
    shfmt
    signal-desktop
    slurp
    stylua
    swaybg
    swayidle
    swaylock
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
  ];

  home.stateVersion = "23.05";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  programs = {
    # Let Home Manager install and manage itself
    home-manager.enable = true;

    # Git
    git = {
      enable = true;
      userName = "Lena Fuhrimann";
      userEmail = "6780471+cloudlena@users.noreply.github.com";
      signing = {
        key = null;
        signByDefault = true;
      };
      diff-so-fancy.enable = true;
    };

    # GPG
    gpg.enable = true;

    # Fuzzy finder
    fzf.enable = true;

    # Fast grepping
    ripgrep.enable = true;

    # Quick navigation
    zoxide.enable = true;

    # Password manager
    browserpass.enable = true;

    # JSON parser
    jq.enable = true;

    # PDF viewer
    zathura.enable = true;

    # Task management
    taskwarrior.enable = true;

    # Media player
    mpv.enable = true;

    # Go
    go.enable = true;
  };

  services = {
    # GPG
    gpg-agent.enable = true;

    # Notifications
    mako.enable = true;

    # Adjust color temperature to reduce eye strain
    gammastep = {
      enable = true;
      provider = "geoclue2";
    };

    # Battery signal demon
    batsignal.enable = true;
  };

  # Dotfiles
  home.file = {
    ".zshrc".source = ./zsh/.zshrc;
    ".zshenv".source = ./zsh/.zshenv;
    ".zpreztorc".source = ./zsh/.zpreztorc;
    ".zsh.d".source = ./zsh/.zsh.d;
  };
  xdg.configFile = {
    "alacritty".source = ./alacritty;
    "gopass".source = ./gopass;
    "hypr".source = ./hyprland;
    "mako".source = ./mako;
    "nvim/init.lua".source = ./nvim/init.lua;
    "nvim/lua".source = ./nvim/lua;
    "sway".source = ./sway;
    "tmux".source = ./tmux;
    "vifm".source = ./vifm;
    "waybar".source = ./waybar;
    "wofi".source = ./wofi;
    "workstyle".source = ./workstyle;
    "wallpapers".source = ./wallpapers;
  };
}
