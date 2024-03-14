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

    # File manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    # Encryption
    gpg.enable = true;

    # Fuzzy finder
    fzf.enable = true;

    # Fast grepping
    ripgrep.enable = true;

    # Process viewer
    bottom.enable = true;

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

  home.packages = with pkgs; [
    altair
    awscli2
    bottles
    brave
    cargo
    chatgpt-cli
    clippy
    curl
    diff-so-fancy
    dig
    dust
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
    moq
    nmap
    nodejs
    nodePackages.svgo
    opentofu
    optipng
    poetry
    pulsemixer
    pwgen
    python3
    quickemu
    rustc
    shellcheck
    signal-desktop
    slides
    termshark
    tflint
    timewarrior
    tree
    unzip
    upterm
    wf-recorder
    wget
    whois
    wl-clipboard
    xdg-utils
    yq
    zip
  ];

  xdg = {
    configFile = {
      "gopass/config".text = ''
        [core]
        	notifications = false
        	showsafecontent = true
        [mounts]
        	path = ${config.home.homeDirectory}/.password-store
      '';
    };
    dataFile = {
      "task/hooks/on-modify.timewarrior" = {
        source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
        executable = true;
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/svg" = [ "imv.desktop" ];
      };
    };
  };
}
