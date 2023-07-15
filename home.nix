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
    file
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
    libwebp
    lldb
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
    terraform
    terraform-ls
    tflint
    timewarrior
    tree
    vscode-langservers-extracted
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
    f = "joshuto";
    g = "gitui";
    t = "task";
    ".." = "cd ..";
    "..." = "cd ../..";
  };

  home.stateVersion = "23.05";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  programs = {
    # Let Home Manager install and manage itself
    home-manager.enable = true;

    # Window manager
    # sway = {
    #   enable = true;
    #   modifier = "Mod4";
    #   terminal = "alacritty";
    #   colors.focused = {
    #     border = "#bb9af7";
    #     text = "#c0caf5";
    #   };
    #   seat."*".hide_cursor = 8000;
    #   input = {
    #     "type:touchpad" = {
    #       tap = "enabled";
    #       natural_scroll = "enabled";
    #     };
    #     "type:keyboard" = {
    #       xkb_options = "caps:escape,compose:ralt";
    #     };
    #   };
    #   output."*".bg = "~/.local/share/wallpapers/bespinian.png fill";
    # };

    # Status bar
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          modules-left = [ "sway/workspaces" "sway/mode" ];
          modules-center = [ "custom/tasks" ];
          modules-right = [
            "custom/containers"
            "wireplumber"
            "bluetooth"
            "network"
            "battery"
            "clock"
          ];
          battery = {
            states = {
              warning = 20;
              critical = 1;
            };
            format = "<span size=\"96%\">{icon}</span>";
            format-icons = {
              default = [ "󰁺" "󰁻" "󰁼" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
              charging = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
              critical = [ "󱃍" ];
            };
            tooltip-format = "Battery at {capacity}%";
          };
          clock = {
            format = "{:%a %d %b %H:%M}";
            tooltip-format = "<big>{:%B %Y}</big>\n\n<tt><small>{calendar}</small></tt>";
          };
          network = {
            format-ethernet = "󰈀";
            format-wifi = "{icon}";
            format-linked = "󰈀";
            format-disconnected = "󰖪";
            format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
            tooltip-format-wifi = "{essid} at {signalStrength}%";
          };
          wireplumber = {
            format = "<span size=\"120%\">{icon}</span>";
            format-muted = "<span size=\"120%\">󰸈</span>";
            format-icons = [ "󰕿" "󰖀" "󰕾" ];
            tooltip-format = "Volume at {volume}%";
          };
          bluetooth = {
            format = "";
            format-on = "<span size=\"105%\">󰂯</span>";
            format-connected = "<span size=\"105%\">󰂱</span>";
            tooltip-format-on = "Bluetooth {status}";
            tooltip-format-connected = "Connected to {device_alias}";
          };
          "custom/tasks" = {
            exec = pkgs.writeShellScript "waybar-tasks" ''
              #!/bin/sh

              set -u

              if [ ! -x "$(command -v task)" ]; then
              	exit 1
              fi

              active_task=$(task rc.verbose=nothing rc.report.activedesc.filter=+ACTIVE rc.report.activedesc.columns:description rc.report.activedesc.sort:urgency- rc.report.activedesc.columns:description activedesc limit:1 | head -n 1)
              if [ -n "$active_task" ]; then
              	echo "󰐌 $active_task"
              	exit 0
              fi

              ready_task=$(task rc.verbose=nothing rc.report.readydesc.filter=+READY rc.report.readydesc.columns:description rc.report.readydesc.sort:urgency- rc.report.readydesc.columns:description readydesc limit:1 | head -n 1)
              if [ -z "$ready_task" ]; then
              	echo ""
              	exit 0
              fi

              echo "󰳟 $ready_task"
            '';
            exec-if = "which task";
            interval = 6;
          };
          "custom/containers" = {
            exec = pkgs.writeShellScript "waybar-containers" ''
              #!/bin/sh

              set -u

              if [ ! -x "$(command -v podman)" ]; then
              	exit 1
              fi

              running_container_count=$(podman ps --noheading | wc -l)

              if [ "$running_container_count" -eq 0 ]; then
              	echo ""
              exit 0
              fi

              suffix=""
              if [ "$running_container_count" -gt 1 ]; then
                suffix = "s"
              fi

              echo "{\"text\": \"󰡨\", \"tooltip\": \"$running_container_count container$suffix running\"}"
            '';
            exec-if = "which podman";
            interval = 60;
            return-type = "json";
          };
        };
      };
      style = ''
        /* General */
        * {
          border-radius: 0;
          font-family: "FiraCode Nerd Font";
          font-size: 13px;
          color: #c0caf5;
          }

          window#waybar {
          background-color: #1a1b26;
          }

          tooltip {
          background-color: #15161e;
          }

          /* Workspaces */
          #workspaces button {
          margin: 4px;
          padding: 0 8px;
          border-radius: 9999px;
          }

          #workspaces button:hover {
          border-color: transparent;
          box-shadow: none;
          background: #414868;
          }

          #workspaces button.focused,
          #workspaces button.active {
          padding: 0 13px;
          background: #2f334d;
          }

          /* Modules */
          #clock,
          #network,
          #wireplumber,
          #bluetooth,
          #battery,
          #custom-updates,
          #custom-tasks,
          #custom-containers,
          #mode {
          margin: 4px;
          padding: 0 13px;
          border-radius: 9999px;
          background-color: #2f334d;
          }

          #network {
          padding: 0 15px 0 11px;
          }

          #mode,
          #custom-updates {
          color: #bb9af7;
          font-weight: bold;
          }

          #battery.critical {
          color: #f7768e;
          font-weight: bold;
          }
      '';
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
      diff-so-fancy.enable = true;
    };
    gitui.enable = true;

    # File manager
    joshuto.enable = true;

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
          { name = "svelte"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "svelte" ]; }; }
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
        format = "$jobs$directory$git_branch$git_state$git_status$character";
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

    # Lock screen manager
    swaylock = {
      enable = true;
      settings = {
        image = "~/.local/share/wallpapers/bespinian.png";
      };
    };
  };

  services = {
    # GPG
    gpg-agent.enable = true;

    # Idle manager
    swayidle = {
      enable = true;
      timeouts = [
        { timeout = 900; command = "swaylock -f"; }
        { timeout = 1200; command = "swaymsg 'output * dpms off'"; }
        { timeout = 1800; command = "systemctl suspend"; }
      ];
      events = [
        { event = "lock"; command = "swaylock -f"; }
        { event = "before-sleep"; command = "playerctl pause"; }
        { event = "before-sleep"; command = "swaylock -f"; }
        { event = "after-resume"; command = "swaymsg 'output * dpms on'"; }
      ];
    };

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
    "sway".source = ./sway;
    "workstyle".source = ./workstyle;
    "zsh".source = ./zsh;
  };

  xdg.dataFile = {
    "wallpapers".source = ./wallpapers;
  };
}

