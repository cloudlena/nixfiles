{ config, pkgs, ... }:

let
  theme = import ./theme.nix;
in
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
      userName = "Lena Fuhrimann";
      userEmail = "6780471+cloudlena@users.noreply.github.com";
      signing = {
        key = null;
        signByDefault = true;
      };
      delta = {
        enable = true;
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
    };
    gitui.enable = true;

    # System information
    fastfetch.enable = true;

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

    # AI coding agent
    opencode = {
      enable = true;
      settings.theme = theme.slug;
    };

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
    bluetui
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
    quickemu
    rustc
    shellcheck
    signal-desktop
    tflint
    timewarrior
    traceroute
    tree
    unzip
    upterm
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
        exec = "brave --app=https://open.spotify.com/";
        categories = [
          "Application"
          "Music"
        ];
        icon = "${config.gtk.iconTheme.package}/share/icons/${theme.icons}/32x32/apps/spotify.svg";
      };
    };
  };
}
