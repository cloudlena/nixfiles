{ config, pkgs, ... }:

let
  theme = import ./theme.nix;
in
{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "${pkgs.kitty}/bin/kitty";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$launcherCmd" = "${pkgs.fuzzel}/bin/fuzzel --prompt '󱉺 ' --icon-theme ${theme.icons}";
      "$osdCmd" =
        "${pkgs.swayosd}/bin/swayosd-client --monitor \"$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true).name')\"";
      "$screenshotsDir" = "${config.xdg.userDirs.pictures}/Screenshots";
      general = {
        border_size = 2;
        gaps_in = 0;
        gaps_out = 0;
        "col.active_border" = "rgb(${theme.colors.primary})";
      };
      input = {
        kb_options = "caps:escape,compose:ralt";
        touchpad.natural_scroll = true;
        special_fallthrough = true;
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_min_speed_to_force = 5;
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      cursor.inactive_timeout = 8;
      monitor = [
        "eDP-1,preferred,auto,1.5"
        ",preferred,auto-center-up,auto"
      ];
      # Smart gaps
      windowrule = [ "bordersize 0, floating:0, onworkspace:w[tv1]" ];
      animations.enabled = false;
      dwindle = {
        # Put new splits on the right/bottom
        force_split = 2;
        special_scale_factor = 0.95;
      };
      bind = [
        # Window manager
        "$mod, Tab, focusurgentorlast"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"

        # Shortcuts
        ", XF86Search, exec, $launcherCmd"
        "$mod, Space, exec, $launcherCmd"
        "$mod, Return, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, W, exec, ${pkgs.brave}/bin/brave"
        "$mod, C, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt '󰆏 ' | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mod, E, exec, ${pkgs.bemoji}/bin/bemoji -n"
        "$mod, P, exec, ${pkgs.hyprpicker}/bin/hyprpicker --autocopy"
        "SUPER_CTRL, Q, exec, ${pkgs.systemd}/bin/loginctl lock-session"

        # Screenshots
        ", Print, exec, mkdir -p $screenshotsDir; ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" \"$screenshotsDir/$(date +'%F-%H%M%S').png\""
        "SHIFT, Print, exec, mkdir -p $screenshotsDir; ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" -t ppm - | ${pkgs.satty}/bin/satty --early-exit --initial-tool brush --filename - --output-filename \"$screenshotsDir/$(date +'%F-%H%M%S').png\""

        # Move window focus
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        # Move window
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod, N, workspace, emptym"
        "$mod, S, togglespecialworkspace"
        "$mod, mouse_down, workspace, m+1"
        "$mod, mouse_up, workspace, m-1"

        # Move active window to workspace
        "$mod SHIFT, N, movetoworkspace, emptym"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod SHIFT, S, movetoworkspacesilent, special"
      ];
      bindl = [
        ", XF86AudioPlay, exec, $osdCmd --playerctl play-pause"
        ", XF86AudioNext, exec, $osdCmd --playerctl next"
        ", XF86AudioPrev, exec, $osdCmd --playerctl previous"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, $osdCmd --output-volume raise --max-volume 120"
        ", XF86AudioLowerVolume, exec, $osdCmd --output-volume lower --max-volume 120"
        ", XF86AudioMute, exec, $osdCmd --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, $osdCmd --input-volume mute-toggle"
        ", XF86MonBrightnessUp, exec, $osdCmd --brightness raise"
        ", XF86MonBrightnessDown, exec, $osdCmd --brightness lower"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      ecosystem = {
        "no_update_news" = true;
        "no_donation_nag" = true;
      };
    };
  };

  programs = {
    # Launcher
    fuzzel = {
      enable = true;
      settings = {
        main = {
          width = 70;
          horizontal-pad = 10;
          vertical-pad = 10;
          inner-pad = 10;
          line-height = 25;
        };
        border.width = 3;
        colors = {
          background = "${theme.colors.background}ff";
          text = "${theme.colors.foreground}ff";
          match = "${theme.colors.primary}ff";
          selection = "${theme.colors.backgroundLight}ff";
          selection-match = "${theme.colors.primary}ff";
          selection-text = "${theme.colors.foreground}ff";
          border = "${theme.colors.primary}ff";
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
        preload = [ "${config.xdg.dataHome}/wallpapers/bespinian.png" ];
        wallpaper = [ ",${config.xdg.dataHome}/wallpapers/bespinian.png" ];
        splash = false;
        ipc = false;
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

    # Clipboard manager
    cliphist.enable = true;

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
    package = pkgs.posy-cursors;
    name = "Posy_Cursor";
  };

  # Wallpaper
  xdg.dataFile = {
    "wallpapers/bespinian.png".source = ./wallpapers/bespinian.png;
  };

  gtk = {
    enable = true;
    theme = {
      name = theme.name;
      package = pkgs.tokyonight-gtk-theme;
    };
    font = {
      name = theme.font;
      package = pkgs.nerd-fonts.fira-code;
      size = 10;
    };
    iconTheme = {
      name = theme.icons;
      package = pkgs.papirus-icon-theme;
    };
  };
}
