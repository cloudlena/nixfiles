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
      delta = {
        enable = true;
        options = {
          minus-style = "red #37222c";
          minus-emph-style = "red #713137";
          plus-style = "green #20303b";
          plus-emph-style = "green #2c5a66";
          zero-style = "white";
          line-numbers = true;
          line-numbers-minus-style = "white #37222c";
          line-numbers-plus-style = "white #20303b";
          line-numbers-zero-style = "white";
        };
      };
    };
    gitui.enable = true;

    # File manager
    yazi.enable = true;

    # Encryption
    gpg.enable = true;

    # Fuzzy finder
    fzf.enable = true;

    # Faster find
    fd.enable = true;

    # Fast grepping
    ripgrep.enable = true;

    # Process viewer
    bottom.enable = true;

    # Quick navigation
    zoxide.enable = true;

    # Password manager
    browserpass = {
      enable = true;
      browsers = [ "brave" ];
    };

    # JSON parser
    jq.enable = true;

    # PDF viewer
    zathura.enable = true;

    # Task management
    taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
    };

    # Media player
    mpv.enable = true;

    # GitHub CLI
    gh.enable = true;

    # Image viewer
    imv.enable = true;

    # AI CLI
    aichat.enable = true;

    # Go
    go.enable = true;

    # Python
    uv.enable = true;

    # Simplified manuals
    tealdeer = {
      enable = true;
      settings = {
        updates.auto_update = true;
      };
    };

    # AWS CLI
    awscli.enable = true;
  };

  home.packages = with pkgs; [
    air
    altair
    brave
    cargo
    clippy
    delta
    dig
    dust
    fx
    gcc
    gimp3
    gnumake
    golangci-lint
    gopass
    hugo
    inkscape
    jpegoptim
    kooha
    kubectl
    kubectx
    libreoffice
    libwebp
    lolcat
    moq
    nodejs
    nodePackages.svgo
    opentofu
    optipng
    podman-compose
    presenterm
    pulsemixer
    pwgen
    python3
    quickemu
    rustc
    shellcheck
    signal-desktop-bin
    tflint
    timewarrior
    tree
    unzip
    upterm
    usbutils
    whois
    wireguard-tools
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
