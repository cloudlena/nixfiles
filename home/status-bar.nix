{ pkgs, ... }:

let
  theme = import ./theme.nix;
in
{
  programs.waybar = {
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
          "privacy"
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
          format-critical = "<span size=\"96%\">{icon} {capacity}%</span>";
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
            critical = [ "󰂃" ];
          };
          tooltip-format = "Battery at {capacity}%";
        };
        bluetooth = {
          format = "";
          format-on = "<span size=\"105%\">󰂯</span>";
          format-connected = "<span size=\"105%\">󰂱</span>";
          tooltip-format-on = "Bluetooth {status}";
          tooltip-format-connected = "Connected to {device_alias} ({device_battery_percentage}% battery)";
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
          tooltip-format-wifi = "Conntected to {essid} at {signalStrength}%";
        };
        privacy = {
          icon-size = 12;
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

    style = # css
      ''
        * {
          border-radius: 0;
          font-family: ${theme.font};
          font-size: 13px;
        }

        window#waybar {
          background-color: #${theme.colors.background};
          color: #${theme.colors.foreground};
        }

        tooltip {
          background-color: #${theme.colors.backgroundDark};
        }

        #workspaces button {
          margin: 4px;
          padding: 0 8px;
          border-radius: 9999px;
        }

        #workspaces button:hover {
          border-color: transparent;
          box-shadow: none;
          background: #${theme.colors.backgroundLight};
        }

        #workspaces button.active {
          padding: 0 13px;
          background: #${theme.colors.primary};
          color: #${theme.colors.background};
          font-weight: bold;
        }

        #battery,
        #bluetooth,
        #clock,
        #mode,
        #network,
        #privacy,
        #wireplumber,
        #custom-updates,
        #custom-tasks,
        #custom-containers {
          margin: 4px;
          padding: 0 13px;
          border-radius: 9999px;
          background-color: #${theme.colors.backgroundLight};
        }

        #network {
          padding: 0 15px 0 11px;
        }

        #mode,
        #custom-updates {
          color: #${theme.colors.primary};
          font-weight: bold;
          padding: 0 15px 0 12px;
        }

        #privacy,
        #battery.critical {
          color: #${theme.colors.danger};
          font-weight: bold;
        }
      '';
  };
}
