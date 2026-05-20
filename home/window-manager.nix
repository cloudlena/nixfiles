{
  config,
  pkgs,
  lib,
  theme,
  ...
}:

{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "${pkgs.kitty}/bin/kitty";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitors
      monitor = [
        {
          output = "eDP-1";
          mode = "preferred";
          position = "auto";
          scale = 1.5;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto-center-up";
          scale = "auto";
        }
      ];

      # My Programs
      launcher._var = "${pkgs.vicinae}/bin/vicinae vicinae://toggle";
      osd._var = "${pkgs.swayosd}/bin/swayosd-client --monitor \"$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true).name')\"";
      screenshots_dir._var = "${config.xdg.userDirs.pictures}/Screenshots";

      # Look and Feel
      config = {
        general = {
          border_size = 2;
          gaps_in = 0;
          gaps_out = 0;
          col.active_border = "rgb(${theme.colors.primary})";
        };
        animations.enabled = false;
        dwindle = {
          force_split = 2;
          special_scale_factor = 0.95;
        };
        input = {
          kb_options = "caps:escape,compose:ralt";
          special_fallthrough = true;
          touchpad.natural_scroll = true;
        };
        gestures.workspace_swipe_min_speed_to_force = 5;
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
        cursor.inactive_timeout = 8;
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
      };

      # Keybindings
      bind = [
        # Window manager
        {
          _args = [
            "SUPER + Tab"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"previous_per_monitor\" })")
          ];
        }
        {
          _args = [
            "SUPER + Q"
            (lib.generators.mkLuaInline "hl.dsp.window.close()")
          ];
        }
        {
          _args = [
            "SUPER + F"
            (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
          ];
        }
        {
          _args = [
            "SUPER + V"
            (lib.generators.mkLuaInline "hl.dsp.window.float()")
          ];
        }
        {
          _args = [
            "SUPER + Y"
            (lib.generators.mkLuaInline "hl.dsp.window.pin()")
          ];
        }

        # Shortcuts
        {
          _args = [
            "SUPER + Space"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(launcher)")
          ];
        }
        {
          _args = [
            "SUPER + Return"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.kitty}/bin/kitty\")")
          ];
        }
        {
          _args = [
            "SUPER + W"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.brave}/bin/brave\")")
          ];
        }
        {
          _args = [
            "SUPER + A"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.vicinae}/bin/vicinae vicinae://launch/wm/switch-windows\")")
          ];
        }
        {
          _args = [
            "SUPER + C"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.vicinae}/bin/vicinae vicinae://launch/clipboard/history\")")
          ];
        }
        {
          _args = [
            "SUPER + E"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.vicinae}/bin/vicinae vicinae://launch/core/search-emojis\")")
          ];
        }
        {
          _args = [
            "SUPER + P"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.hyprpicker}/bin/hyprpicker --autocopy\")")
          ];
        }
        {
          _args = [
            "SUPER + CTRL + Q"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.systemd}/bin/loginctl lock-session\")")
          ];
        }

        # Screenshots
        {
          _args = [
            "Print"
            (lib.generators.mkLuaInline "hl.dsp.exec_raw(\"mkdir -p \" .. screenshots_dir .. \"; ${pkgs.grim}/bin/grim -g $(${pkgs.slurp}/bin/slurp) \" .. screenshots_dir .. \"/$(date +'%F-%H%M%S').png\")")
          ];
        }
        {
          _args = [
            "SHIFT + Print"
            (lib.generators.mkLuaInline "hl.dsp.exec_raw(\"mkdir -p \" .. screenshots_dir .. \"; ${pkgs.grim}/bin/grim -g $(${pkgs.slurp}/bin/slurp) -t ppm - | ${pkgs.satty}/bin/satty --filename - --output-filename \" .. screenshots_dir .. \"/$(date +'%F-%H%M%S').png\")")
          ];
        }

        # Move Window focus
        {
          _args = [
            "SUPER + H"
            (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"left\" })")
          ];
        }
        {
          _args = [
            "SUPER + J"
            (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"down\" })")
          ];
        }
        {
          _args = [
            "SUPER + K"
            (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"up\" })")
          ];
        }
        {
          _args = [
            "SUPER + L"
            (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"right\" })")
          ];
        }

        # Move Window
        {
          _args = [
            "SUPER + SHIFT + H"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"left\" })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + J"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"down\" })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + K"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"up\" })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + L"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"right\" })")
          ];
        }

        # Workspaces
        {
          _args = [
            "SUPER + 1"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 1 })")
          ];
        }
        {
          _args = [
            "SUPER + 2"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 2 })")
          ];
        }
        {
          _args = [
            "SUPER + 3"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 3 })")
          ];
        }
        {
          _args = [
            "SUPER + 4"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 4 })")
          ];
        }
        {
          _args = [
            "SUPER + 5"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 5 })")
          ];
        }
        {
          _args = [
            "SUPER + 6"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 6 })")
          ];
        }
        {
          _args = [
            "SUPER + 7"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 7 })")
          ];
        }
        {
          _args = [
            "SUPER + 8"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 8 })")
          ];
        }
        {
          _args = [
            "SUPER + 9"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 9 })")
          ];
        }
        {
          _args = [
            "SUPER + 0"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 10 })")
          ];
        }
        {
          _args = [
            "SUPER + N"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"emptym\" })")
          ];
        }
        {
          _args = [
            "SUPER + S"
            (lib.generators.mkLuaInline "hl.dsp.workspace.toggle_special()")
          ];
        }
        {
          _args = [
            "SUPER + bracketleft"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"m-1\"})")
          ];
        }
        {
          _args = [
            "SUPER + bracketright"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"m+1\"})")
          ];
        }
        {
          _args = [
            "SUPER + mouse_up"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"m-1\"})")
          ];
        }
        {
          _args = [
            "SUPER + mouse_down"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"m+1\"})")
          ];
        }

        {
          _args = [
            "SUPER + SHIFT + 1"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 1 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 2"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 2 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 3"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 3 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 4"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 4 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 5"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 5 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 6"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 6 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 7"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 7 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 8"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 8 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 9"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 9 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 0"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 10 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + N"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"emptym\" })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + bracketleft"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"m-1\" })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + bracketright"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"m+1\" })")
          ];
        }

        {
          _args = [
            "SUPER + mouse:272"
            (lib.generators.mkLuaInline "hl.dsp.window.drag()")
            (lib.generators.mkLuaInline "{ mouse = true }")
          ];
        }
        {
          _args = [
            "SUPER + mouse:273"
            (lib.generators.mkLuaInline "hl.dsp.window.resize()")
            (lib.generators.mkLuaInline "{ mouse = true }")
          ];
        }

        {
          _args = [
            "XF86AudioPlay"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(osd .. \" --playerctl play-pause\")")
            (lib.generators.mkLuaInline "{ locked = true }")
          ];
        }
        {
          _args = [
            "XF86AudioNext"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(osd .. \" --playerctl next\")")
            (lib.generators.mkLuaInline "{ locked = true }")
          ];
        }
        {
          _args = [
            "XF86AudioPrev"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(osd .. \" --playerctl previous\")")
            (lib.generators.mkLuaInline "{ locked = true }")
          ];
        }
        {
          _args = [
            "XF86AudioMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(osd .. \" --output-volume mute-toggle\")")
            (lib.generators.mkLuaInline "{ locked = true }")
          ];
        }
        {
          _args = [
            "XF86AudioMicMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(osd .. \" --input-volume mute-toggle\")")
            (lib.generators.mkLuaInline "{ locked = true }")
          ];
        }
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(osd .. \" --output-volume raise --max-volume 120\")")
            (lib.generators.mkLuaInline "{ locked = true, repeating = true }")
          ];
        }
        {
          _args = [
            "XF86AudioLowerVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(osd .. \" --output-volume lower --max-volume 120\")")
            (lib.generators.mkLuaInline "{ locked = true, repeating = true }")
          ];
        }
        {
          _args = [
            "XF86MonBrightnessUp"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(osd .. \" --brightness raise\")")
            (lib.generators.mkLuaInline "{ locked = true, repeating = true }")
          ];
        }
        {
          _args = [
            "XF86MonBrightnessDown"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(osd .. \" --brightness lower\")")
            (lib.generators.mkLuaInline "{ locked = true, repeating = true }")
          ];
        }
      ];

      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
      ];

      # Windows and Workspaces
      window_rule = [
        {
          match = {
            float = false;
            workspace = "w[tv1]";
          };
          border_size = 0;
        }
      ];
    };
  };

  programs = {
    # Launcher
    vicinae = {
      enable = true;
      systemd.enable = true;
      settings = {
        theme.dark.name = "tokyo-night";
        font.normal.family = theme.font;
        pop_to_root_on_close = true;
      };
    };
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
    gtk4.theme = config.gtk.theme;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
