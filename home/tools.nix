{
  config,
  pkgs,
  theme,
  ...
}:

{
  programs = {
    # Nix helper
    nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/.nixfiles";
    };

    # Git
    git = {
      enable = true;
      signing = {
        key = null;
        signByDefault = true;
      };
      settings = {
        user = {
          name = "Lena Fuhrimann";
          email = "6780471+cloudlena@users.noreply.github.com";
        };
      };
    };

    # Git TUI
    gitui.enable = true;

    # Diff viewer
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        minus-style = "red #${theme.colors.dangerDark}";
        minus-emph-style = "red #${theme.colors.dangerLight}";
        plus-style = "green #${theme.colors.successDark}";
        plus-emph-style = "green #${theme.colors.successLight}";
        zero-style = "white";
        line-numbers = true;
        line-numbers-minus-style = "white #${theme.colors.dangerDark}";
        line-numbers-plus-style = "white #${theme.colors.successDark}";
        line-numbers-zero-style = "white";
      };
    };

    # Merge tool
    mergiraf.enable = true;

    # System information tool
    fastfetch.enable = true;

    # Screenshot annotation tool
    satty = {
      enable = true;
      settings = {
        general = {
          early-exit = true;
          initial-tool = "brush";
        };
      };
    };

    # Agentic coding tool
    claude-code.enable = true;

    # File manager
    yazi.enable = true;

    # Encryption
    gpg.enable = true;

    # Fuzzy finder
    fzf.enable = true;

    # Faster find
    fd.enable = true;

    # Faster grepping
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

    # Task manager
    taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      colorTheme = "dark-violets-256";
    };

    # Media player
    mpv.enable = true;

    # GitHub CLI
    gh.enable = true;

    # Image viewer
    imv.enable = true;

    # Simplified man pages
    tealdeer = {
      enable = true;
      settings = {
        updates.auto_update = true;
      };
    };

    # AWS CLI
    awscli.enable = true;

    # Go
    go.enable = true;

    # Python package manager
    uv.enable = true;
  };

  home.packages = with pkgs; [
    air
    altair
    bluetui
    brave
    cargo
    clippy
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
    killall
    kooha
    kubectl
    kubectx
    libreoffice
    libwebp
    lolcat
    moq
    nodejs
    nodePackages.svgo
    onefetch
    opentofu
    optipng
    podman-compose
    presenterm
    pwgen
    python3
    qrencode
    quickemu
    rustc
    shellcheck
    signal-desktop
    tflint
    timewarrior
    traceroute
    tree
    unzip
    usbutils
    whois
    wiremix
    wl-clipboard
    xdg-utils
    yq-go
    zip
  ];

  xdg = {
    configFile = {
      "gopass/config".text = # ini
        ''
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
    desktopEntries = {
      spotify = {
        name = "Spotify";
        genericName = "Music Player";
        icon = "${config.gtk.iconTheme.package}/share/icons/${theme.icons}/32x32/apps/spotify.svg";
        exec = "brave --app=https://open.spotify.com/";
        categories = [
          "AudioVideo"
          "Audio"
          "Player"
        ];
      };
    };
  };
}
