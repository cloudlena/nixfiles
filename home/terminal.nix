{ theme, ... }:

{
  programs = {
    # Terminal emulator
    kitty = {
      enable = true;
      font.name = theme.font;
      themeFile = "tokyo_night_night";
      keybindings = {
        "ctrl+shift+n" = "new_os_window_with_cwd";
      };
      settings = {
        window_padding_width = 5;
      };
    };

    # Terminal multiplexer
    herdr = {
      enable = true;
      settings = {
        onboarding = false;
        theme.name = "tokyo-night";
      };
    };
  };
}
