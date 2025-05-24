{
  programs = {
    # Terminal emulator
    kitty = {
      enable = true;
      font.name = "FiraCode Nerd Font";
      themeFile = "tokyo_night_night";
      keybindings = {
        "ctrl+shift+n" = "new_os_window_with_cwd";
      };
      settings = {
        window_padding_width = 5;
      };
    };

    # Terminal multiplexer
    tmux = {
      enable = true;
      keyMode = "vi";
      escapeTime = 10;
      terminal = "tmux-256color";
      extraConfig = ''
        # Use 24-bit color
        set-option -sa terminal-features ',kitty*:RGB'

        # Open new splits from current directory
        bind '"' split-window -v -c '#{pane_current_path}'
        bind % split-window -h -c '#{pane_current_path}'

        # Unclutter status bar
        set-option -g status-right ""
        set-option -g status-left ""
        set-window-option -g window-status-format " #I: #W "
        set-window-option -g window-status-current-format " #I: #W "

        # Color scheme
        set-option -g status-style 'fg=#414868'
        set-option -g window-status-current-style 'fg=#1a1b26,bg=#414868,bold'
        set-option -g mode-style 'fg=#7aa2f7,bg=#3b4261'
        set-option -g message-style 'fg=#7aa2f7,bg=#3b4261'
        set-option -g pane-border-style 'fg=#3b4261'
        set-option -g pane-active-border-style 'fg=#3b4261'
        set-option -g message-command-style 'fg=#7aa2f7,bg=#3b4261'
      '';
    };
  };
}
