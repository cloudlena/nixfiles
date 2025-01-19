{ config, pkgs, ... }:

{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$launcherCmd" = "${pkgs.fuzzel}/bin/fuzzel --prompt '󱉺 ' --icon-theme Papirus";
      general = {
        border_size = 2;
        gaps_in = 0;
        gaps_out = 0;
        "col.active_border" = "rgb(bb9af7)";
      };
      input = {
        kb_options = "caps:escape,compose:ralt";
        touchpad.natural_scroll = true;
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
      monitor = "eDP-1,preferred,auto,1.5";
      # Smart gaps
      windowrulev2 = [ "bordersize 0, floating:0, onworkspace:w[tv1]" ];
      animations.enabled = false;
      dwindle = {
        # Put new splits on the right/bottom
        force_split = 2;
      };
      bind = [
        # Window manager
        "$mod, Tab, focusurgentorlast"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, S, togglefloating"

        # Shortcuts
        "$mod, Space, exec, $launcherCmd"
        "$mod, Return, exec, ${pkgs.alacritty}/bin/alacritty"
        "$mod, W, exec, ${pkgs.brave}/bin/brave"
        "$mod, C, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt '󰆏 ' | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mod, E, exec, ${pkgs.bemoji}/bin/bemoji -n"
        "$mod, P, exec, ${pkgs.hyprpicker}/bin/hyprpicker --autocopy"
        "SUPER_CTRL, Q, exec, ${pkgs.systemd}/bin/loginctl lock-session"

        # Media keys
        ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}playerctl previous"
        ", XF86Search, exec, $launcherCmd"

        # Screenshots
        ", Print, exec, mkdir -p ${config.xdg.userDirs.pictures}; ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" \"${config.xdg.userDirs.pictures}/Screenshot-$(date +'%F-%H-%M-%S').png\""

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
        "$mod, N, workspace, emptym"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, togglespecialworkspace"
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
        "$mod SHIFT, 0, movetoworkspacesilent, special"
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
    # Status bar
    waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "custom/tasks" ];
          modules-right = [
            "custom/updates"
            "custom/containers"
            "wireplumber"
            "bluetooth"
            "network"
            "battery"
            "clock"
          ];
          battery = {
            states = {
              critical = 10;
            };
            format = "<span size=\"96%\">{icon}</span>";
            format-icons = {
              default = [
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
              charging = [
                "󰢜"
                "󰂆"
                "󰂇"
                "󰂈"
                "󰢝"
                "󰂉"
                "󰢞"
                "󰂊"
                "󰂋"
                "󰂅"
              ];
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
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            tooltip-format-wifi = "{essid} at {signalStrength}%";
          };
          wireplumber = {
            format = "<span size=\"120%\">{icon}</span>";
            format-muted = "<span size=\"120%\">󰸈</span>";
            format-icons = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
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
            interval = 60;
          };
          "custom/containers" = {
            exec = pkgs.writeShellScript "waybar-containers" ''
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
          "custom/updates" = {
            format = "<span size=\"120%\">{}</span>";
            exec = pkgs.writeShellScript "waybar-updates" ''
              set -u

              current_timestamp=$(nix flake metadata ~/.nixfiles --json | jq '.locks.nodes.nixpkgs.locked.lastModified')
              latest_timestamp=$(nix flake metadata github:NixOS/nixpkgs/nixos-unstable --json | jq '.locked.lastModified')

              if [ "$latest_timestamp" -le "$current_timestamp" ]; then
                echo ""
                exit 0
              fi

              echo "{\"text\": \"󱄅\", \"tooltip\": \"Updates available\"}"
            '';
            exec-if = "test -d ~/.nixfiles";
            interval = 21600; # 6h
            return-type = "json";
          };
        };
      };
      style = ''
        * {
          border-radius: 0;
          font-family: "FiraCode Nerd Font";
          font-size: 13px;
        }

        window#waybar {
          background-color: #1a1b26;
          color: #c0caf5;
        }

        tooltip {
          background-color: #15161e;
        }

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

        #workspaces button.active {
          padding: 0 13px;
          background: #bb9af7;
          color: #1a1b26;
        }

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
          padding: 0 15px 0 12px;
        }

        #battery.critical {
          color: #f7768e;
          font-weight: bold;
        }
      '';
    };

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
          background = "15161eff";
          text = "c0caf5ff";
          match = "bb9af7ff";
          selection = "343a55ff";
          selection-match = "bb9af7ff";
          selection-text = "c0caf5ff";
          border = "bb9af7ff";
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
            font_color = "rgb(c0caf5)";
            inner_color = "rgb(1a1b26)";
            outer_color = "rgb(1a1b26)";
            check_color = "rgb(e0af68)";
            fail_color = "rgb(f7768e)";
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

    # GPG
    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };

    # Notifications for low battery
    batsignal.enable = true;

    # Notification daemon
    mako = {
      enable = true;
      font = "FiraCode Nerd Font 9";
      backgroundColor = "#15161e";
      borderRadius = 5;
      width = 350;
      height = 120;
      padding = "8,10";
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
      name = "Tokyonight-Dark";
      package = pkgs.tokyo-night-gtk;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };
}
