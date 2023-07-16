{
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

  programs = {
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
      loginExtra = ''
        # Start window manager
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec Hyprland
        fi
      '';
    };

    # Shell prompt
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        aws.disabled = true;
        cmd_duration.disabled = true;
        package.disabled = true;
      };
    };
  };

  # Helper functions
  xdg.configFile = {
    "zsh/functions.zsh".source = ./zsh/functions.zsh;
  };
}
