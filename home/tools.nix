{ pkgs, ... }:

{
  programs = {
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
    gitui.enable = true;

    # Encryption
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
    taskwarrior = {
      enable = true;
      config = {
        taskd = {
          certificate = "~/.config/task/private.certificate.pem";
          key = "~/.config/task/private.key.pem";
          ca = "~/.config/task/ca.cert.pem";
          server = "inthe.am:53589";
          credentials = "inthe_am/lena/c214a5a3-b0b2-4132-958c-ebef8d83fd25";
          trust = "strict";
        };
      };
    };

    # Media player
    mpv.enable = true;

    # Image viewer
    imv.enable = true;

    # Go
    go = {
      enable = true;
      goPath = ".local/share/go";
    };

    # Simplified manuals
    tealdeer = {
      enable = true;
      settings = {
        updates.auto_update = true;
      };
    };
  };

  services = {
    # GPG
    gpg-agent.enable = true;
  };

  home.packages = with pkgs; [
    altair
    awscli2
    brave
    cargo
    chromium
    diff-so-fancy
    dig
    fd
    fx
    gh
    gimp
    gopass
    hugo
    inkscape
    jpegoptim
    kubectl
    kubectx
    libreoffice-fresh
    libwebp
    lolcat
    lutris
    moq
    ncdu
    nmap
    nodejs
    nodePackages.svgo
    optipng
    poetry
    pwgen
    python3
    quickemu
    realvnc-vnc-viewer
    rustc
    signal-desktop
    termshark
    terraform
    timewarrior
    tree
    via
    whois
    wine
    wl-clipboard
    yq
  ];

  xdg.configFile = {
    "gopass/config".source = ./gopass/config;
  };
}
