{ config, pkgs, ... }:

{
  home.username = "lena";
  home.homeDirectory = "/home/lena";

  home.packages = with pkgs; [
    altair
    autotiling-rs
    awscli2
    black
    brave
    brightnessctl
    cargo
    chafa
    chromium
    clipman
    delve
    diff-so-fancy
    dig
    fd
    fira-mono
    fx
    gh
    gimp
    golangci-lint
    gopass
    gopls
    grim
    gron
    hugo
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
    nil
    nixpkgs-fmt
    nmap
    nodejs
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.svelte-language-server
    nodePackages.svgo
    nodePackages.typescript-language-server
    nodePackages.yaml-language-server
    noto-fonts-cjk
    noto-fonts-emoji
    optipng
    playerctl
    poetry
    protobuf
    pwgen
    python3
    python311Packages.python-lsp-server
    quickemu
    realvnc-vnc-viewer
    rust-analyzer
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
    terraform-ls
    tflint
    timewarrior
    tree
    vifm
    vscode-langservers-extracted
    waybar
    wf-recorder
    whois
    wine
    wl-clipboard
    workstyle
  ];

  home.sessionVariables = {
    TERMINAL = "alacritty";
    BROWSER = "brave";
  };

  home.shellAliases = {
    e = "$EDITOR";
    ".." = "cd ..";
    "..." = "cd ../..";
  };

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

    # Text editor
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "tokyonight";
        editor = {
          line-number = "relative";
          mouse = false;
          cursor-shape.insert = "bar";
          file-picker.hidden = false;
        };
      };
      languages = {
        language = [
          { name = "html"; formatter = { command = "prettier"; args = [ "--parser" "html" ]; }; }
          { name = "json"; formatter = { command = "prettier"; args = [ "--parser" "json" ]; }; }
          { name = "css"; formatter = { command = "prettier"; args = [ "--parser" "css" ]; }; }
          { name = "yaml"; formatter = { command = "prettier"; args = [ "--parser" "yaml" ]; }; }
          { name = "markdown"; formatter = { command = "prettier"; args = [ "--parser" "markdown" ]; }; }
          { name = "javascript"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; }; }
          { name = "typescript"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; }; }
          { name = "go"; config = { formatting.gofumpt = true; }; }
          { name = "nix"; auto-format = true; formatter = { command = "nixpkgs-fmt"; }; }
          { name = "bash"; auto-format = true; formatter = { command = "shfmt"; args = [ "-i" "4" ]; }; }
        ];
      };
    };

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

    # Shell
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "viins";
      historySubstringSearch = {
        enable = true;
        searchDownKey = "^N";
        searchUpKey = "^P";
      };
      initExtra = ''
        source ~/.config/zsh/*
        [[ -z "$TMUX" && $(tty) != /dev/tty[0-9] ]] && { tmux || exec tmux new-session && exit }
      '';
    };

    # Shell prompt
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$directory$git_branch$git_status$character";
      };
    };

    # Launcher
    wofi = {
      enable = true;
      style = ''
        #window {
          font-family: "Fira Mono";
          background-color: #1a1b26;
          color: #c0caf5;
        }

        #input {
          border-radius: 0;
          border-color: transparent;
          padding: 5px;
          background-color: #1a1b26;
          color: #c0caf5;
        }

        #entry {
          padding: 5px;
        }

        #entry:selected {
          outline: none;
          background-color: #bb9af7;
        }
      '';
    };

    # Terminal multiplexer
    tmux = {
      enable = true;
      keyMode = "vi";
      escapeTime = 10;
      customPaneNavigationAndResize = true;
      terminal = "tmux-256color";
      extraConfig = ''
        # Set correct terminal
        set-option -sa terminal-features ',alacritty:RGB'

        # Open new splits from current directory
        bind '"' split-window -v -c '#{pane_current_path}'
        bind % split-window -h -c '#{pane_current_path}'

        # Color scheme
        set-option -g status-style 'fg=#414868'
        set-option -g window-status-current-style 'fg=#1a1b26,bg=#414868,bold'
        set-option -g mode-style 'fg=#7aa2f7,bg=#3b4261'
        set-option -g message-style 'fg=#7aa2f7,bg=#3b4261'
        set-option -g pane-border-style 'fg=#3b4261'
        set-option -g pane-active-border-style 'fg=#3b4261'
        set-option -g message-command-style 'fg=#7aa2f7,bg=#3b4261'

        # Unclutter status bar
        set-option -g status-right ""
        set-option -g status-left ""
        set-window-option -g window-status-format " #I: #W "
        set-window-option -g window-status-current-format " #I: #W "
      '';
    };
    tmate.enable = true;

    # Terminal emulator
    alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 5;
            y = 5;
          };
          decorations = "none";
          startup_mode = "Maximized";
        };
        font = {
          normal.family = "FiraCode Nerd Font";
          size = 12;
        };
        colors = {
          primary = {
            background = "#1a1b26";
            foreground = "#c0caf5";
          };
          normal = {
            black = "#15161e";
            red = "#f7768e";
            green = "#9ece6a";
            yellow = "#e0af68";
            blue = "#7aa2f7";
            magenta = "#bb9af7";
            cyan = "#7dcfff";
            white = "#a9b1d6";
          };
          bright = {
            black = "#414868";
            red = "#f7768e";
            green = "#9ece6a";
            yellow = "#e0af68";
            blue = "#7aa2f7";
            magenta = "#bb9af7";
            cyan = "#7dcfff";
            white = "#c0caf5";
          };
          indexed_colors = [
            { index = 16; color = "#ff9e64"; }
            { index = 17; color = "#db4b4b"; }
          ];
        };
      };
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

    # Notification daemon
    mako = {
      enable = true;
      font = "Fira Mono 9";
      backgroundColor = "#1a1b26";
      textColor = "#c0caf5";
      borderColor = "#bb9af7";
      defaultTimeout = 8000;
      groupBy = "app-name,summary";
    };

    # Adjust color temperature to reduce eye strain
    gammastep = {
      enable = true;
      provider = "geoclue2";
    };

    # Battery signal daemon
    batsignal.enable = true;
  };

  xdg.configFile = {
    "gopass".source = ./gopass;
    "hypr".source = ./hyprland;
    "nvim/init.lua".source = ./nvim/init.lua;
    "nvim/lua".source = ./nvim/lua;
    "sway".source = ./sway;
    "vifm".source = ./vifm;
    "wallpapers".source = ./wallpapers;
    "waybar".source = ./waybar;
    "workstyle".source = ./workstyle;
    "zsh".source = ./zsh;
  };
}
