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
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ecdsa";
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

    # Node.js
    npm.enable = true;

    # Python
    uv.enable = true;

    # Spotify player
    ncspot = {
      enable = true;
      settings = {
        shuffle = true;
      };
    };
  };

  home.packages = with pkgs; [
    age
    age-plugin-tpm
    air
    bluetui
    brave-origin
    cargo
    clippy
    dig
    dust
    ffmpeg
    file
    fx
    gcc
    gimp
    gnumake
    golangci-lint
    image_optim
    inkscape
    killall
    kubectl
    kubectx
    libreoffice
    libwebp
    lolcat
    moq
    onefetch
    opentofu
    orca-slicer
    podman-compose
    pwgen
    python3
    quickemu
    rustc
    serve
    shellcheck
    signal-desktop
    tflint
    timewarrior
    traceroute
    tree
    unzip
    usbutils
    wdisplays
    whois
    wiremix
    wl-clipboard
    wl-mirror
    wl-screenrec
    xdg-utils
    yq-go
    yubioath-flutter
    zip
  ];

  xdg = {
    enable = true;
    userDirs.enable = true;
    dataFile = {
      "task/hooks/on-modify.timewarrior" = {
        source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
        executable = true;
      };
      "task/hooks/on-exit.waybar" = {
        source = pkgs.writeShellScript "task-hook-waybar" ''
          pkill -RTMIN+1 '^\.waybar' || true
        '';
        executable = true;
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "image/*" = [ "imv.desktop" ];
      };
    };
  };
  home.preferXdgDirectories = true;

  home.sessionPath = [ "${config.home.homeDirectory}/go/bin" ];
}
