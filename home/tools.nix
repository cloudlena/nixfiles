{ config, pkgs, ... }:

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

    # Process viewer
    htop.enable = true;

    # Quick navigation
    zoxide.enable = true;

    # Password manager
    browserpass.enable = true;

    # JSON parser
    jq.enable = true;

    # PDF viewer
    zathura.enable = true;

    # Share terminal sessions
    tmate.enable = true;

    # Task management
    taskwarrior.enable = true;

    # Media player
    mpv.enable = true;

    # GitHub CLI
    gh.enable = true;

    # Image viewer
    imv.enable = true;

    # Go
    go.enable = true;

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
    curl
    diff-so-fancy
    dig
    fd
    fx
    gcc
    gimp
    gnumake
    golangci-lint
    gopass
    hugo
    inkscape
    jpegoptim
    kubectl
    kubectx
    libreoffice
    libwebp
    lolcat
    lutris
    moq
    ncdu
    ncpamixer
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
    shellcheck
    signal-desktop
    slides
    termshark
    terraform
    tflint
    timewarrior
    tree
    unzip
    wget
    whois
    wl-clipboard
    yq
    zip
  ];

  xdg.configFile = {
    "gopass/config".text = ''
      [core]
      	notifications = false
      	showsafecontent = true
      [mounts]
      	path = ${config.home.homeDirectory}/.password-store
    '';
  };
  xdg.dataFile = {
    "task/hooks/on-modify.timewarrior" = {
      source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
      executable = true;
    };
  };
}
