{
  config,
  pkgs,
  theme,
  ...
}:

{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "${pkgs.kitty}/bin/kitty";
  };

  programs = {
    # Launcher
    rofi = {
      enable = true;
      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
        in
        {
          "*" = {
            background-color = mkLiteral "#${theme.colors.background}";
            foreground-color = mkLiteral "#${theme.colors.foreground}";
          };
        };
    };

    # Screen lock
    hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
        };
        background = [
          {
            path = "${config.xdg.dataHome}/wallpapers/bespinian.png";
            blur_passes = 3;
          }
        ];
        input-field = [
          {
            font_color = "rgb(${theme.colors.foreground})";
            inner_color = "rgb(${theme.colors.background})";
            outer_color = "rgb(${theme.colors.background})";
            check_color = "rgb(${theme.colors.warning})";
            fail_color = "rgb(${theme.colors.danger})";
          }
        ];
      };
    };
  };

  services = {
    # Background image
    hyprpaper = {
      enable = true;
      settings = {
        wallpaper = [
          {
            monitor = "";
            path = "${config.xdg.dataHome}/wallpapers/bespinian.png";
          }
        ];
        splash = false;
      };
    };

    # Idle manager
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 600;
            on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            timeout = 900;
            on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          }
          {
            timeout = 1200;
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };

    # Volume and brightness indicator
    swayosd.enable = true;

    # GPG
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt;
    };

    # Notifications for low battery
    batsignal.enable = true;

    # Notification daemon
    mako = {
      enable = true;
      settings = {
        width = "350";
        height = "120";
        padding = "8,10";
        border-radius = "5";
        default-timeout = "8000";
        group-by = "app-name,summary";
        font = "${theme.font} 9";
        text-color = "#${theme.colors.foreground}";
        background-color = "#${theme.colors.background}";
        border-color = "#${theme.colors.primary}";
        "mode=do-not-disturb" = {
          invisible = 1;
        };
      };
    };

    # Adjust color temperature to reduce eye strain
    gammastep = {
      enable = true;
      provider = "geoclue2";
    };
  };

  # Fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    fira-mono
    lato
    nerd-fonts.fira-code
  ];

  # Cursor
  home.pointerCursor = {
    enable = true;
    package = pkgs.posy-cursors;
    name = "Posy_Cursor";
  };

  # Wallpaper
  xdg.dataFile = {
    "wallpapers/bespinian.png".source = ./wallpapers/bespinian.png;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    font = {
      name = theme.font;
      package = pkgs.nerd-fonts.fira-code;
      size = 10;
    };
    iconTheme = {
      name = theme.icons;
      package = pkgs.papirus-icon-theme;
    };
    gtk4.theme = config.gtk.theme;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
