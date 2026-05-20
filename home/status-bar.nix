{
  config,
  pkgs,
  theme,
  ...
}:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        modules-left = [ "ext/workspaces" ];
        modules-center = [ "custom/tasks" ];
        modules-right = [
          "custom/agents"
          "custom/containers"
          "custom/updates"
          "custom/dnd"
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
        "ext/workspaces" = {
          on-click = "activate";
        };
        bluetooth = {
          format = "";
          format-on = "<span size=\"105%\">󰂯</span>";
          format-connected = "<span size=\"105%\">󰂱</span>";
          tooltip-format-on = "Bluetooth {status}";
          tooltip-format-connected = "Connected to {device_alias} ({device_battery_percentage}% battery)";
          on-click = "${pkgs.kitty}/bin/kitty -e ${pkgs.bluetui}/bin/bluetui";
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
          tooltip-format-wifi = "Connected to {essid} at {signalStrength}%";
          on-click = "${pkgs.kitty}/bin/kitty -e ${pkgs.networkmanager}/bin/nmtui";
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
          on-click = "${pkgs.kitty}/bin/kitty -e ${pkgs.wiremix}/bin/wiremix --tab output";
        };
        "custom/tasks" = {
          exec = pkgs.writeShellScript "waybar-tasks" ''
            set -u

            active_task=$(task rc.verbose=nothing rc.hooks=off rc.report.activedesc.filter=+ACTIVE rc.report.activedesc.columns:description rc.report.activedesc.sort:urgency- activedesc limit:1 | head -n 1)
            if [ -n "$active_task" ]; then
              echo "󰐌 $active_task"
              exit 0
            fi

            ready_task=$(task rc.verbose=nothing rc.hooks=off rc.report.readydesc.filter=+READY rc.report.readydesc.columns:description rc.report.readydesc.sort:urgency- readydesc limit:1 | head -n 1)
            if [ -z "$ready_task" ]; then
              echo ""
              exit 0
            fi

            echo "󰳟 $ready_task"
          '';
          exec-if = "command -v task";
          escape = true;
          signal = 1;
          on-click = "${pkgs.kitty}/bin/kitty -e ${pkgs.taskwarrior-tui}/bin/taskwarrior-tui";
        };
        "custom/agents" = {
          exec = pkgs.writeShellScript "waybar-agents" ''
            set -u

            # Claude Code keeps a file per live session in this directory and
            # rewrites it whenever a session changes state, so watching the
            # directory reacts immediately without polling the CLI in a loop
            sessions_dir="$HOME/.claude/sessions"
            mkdir -p "$sessions_dir"

            while true; do
              sessions=$(${config.programs.claude-code.package}/bin/claude agents --json 2>/dev/null) || sessions=""
              [ -n "$sessions" ] || sessions="[]"

              # One dot per session, coloured by its status. Session names come
              # from directory names and Waybar renders module output as Pango
              # markup, so they get escaped here
              printf '%s' "$sessions" | jq --compact-output '
                def esc: gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;");
                def color:
                  if .status == "waiting" then
                    "#${theme.colors.warning}"
                  else
                    "#${theme.colors.foreground}"
                  end;
                def glyph:
                  if .status == "waiting" then "◒"
                  elif .status == "idle" then "○"
                  else "●"
                  end;
                def dot: "<span color=\"" + color + "\">" + glyph + "</span>";
                def describe:
                  if .status == "waiting" then
                    if .waiting_for then "waiting for you (" + (.waiting_for | esc) + ")" else "waiting for you" end
                  elif .status == "idle" then "idle"
                  else "working"
                  end;

                [
                  .[] | {
                    name: (.name // ((.cwd // "?") | split("/") | last)),
                    status: (.status // "idle"),
                    waiting_for: .waitingFor,
                    background: (.kind == "background"),
                    started_at: .startedAt,
                  }
                ]
                | sort_by(.started_at)
                | if length == 0 then
                    { text: "" }
                  else
                    {
                      text: "󰚩<span letter_spacing=\"5120\"> </span>" + (map(dot) | join(" ")),
                      tooltip: (
                        map(dot + " <b>" + (.name | esc) + "</b>" + (if .background then " (background)" else "" end) + " is " + describe)
                        | join("\n")
                      ),
                    }
                  end
              '

              # The timeout doubles as a slow poll, which retires sessions whose
              # process died without getting a chance to clean its file up
              ${pkgs.inotify-tools}/bin/inotifywait --quiet --quiet --timeout 60 \
                --event create,delete,close_write,moved_to "$sessions_dir" || true
            done
          '';
          return-type = "json";
        };
        "custom/containers" = {
          exec = pkgs.writeShellScript "waybar-containers" ''
            set -u

            render() {
              containers=$(podman ps --format json 2>/dev/null) || containers=""
              [ -n "$containers" ] || containers="[]"

              # One dot per running container, coloured by its health. Waybar
              # renders module output as Pango markup, so the names, which are
              # user-chosen, get escaped here
              printf '%s' "$containers" | jq --compact-output '
                def esc: gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;");
                def ailing: .health == "unhealthy" or .health == "starting";
                def color:
                  if ailing then
                    "#${theme.colors.warning}"
                  else
                    "#${theme.colors.foreground}"
                  end;
                def glyph:
                  if ailing then "◒"
                  elif .state == "paused" then "○"
                  else "●"
                  end;
                def dot: "<span color=\"" + color + "\">" + glyph + "</span>";
                def describe:
                  if .health == "unhealthy" then "unhealthy"
                  elif .health == "starting" then "still starting up"
                  elif .state == "paused" then "paused"
                  else "running"
                  end;

                [
                  .[] | {
                    name: (.Names[0] // (.Id[0:12])),
                    state: (.State // "running"),
                    health: (((.Status // "") | capture("\\((?<h>[a-z]+)\\)") | .h) // null),
                    started_at: .StartedAt,
                  }
                ]
                | sort_by(.started_at)
                | if length == 0 then
                    { text: "" }
                  else
                    {
                      text: "<span letter_spacing=\"5120\"> </span>" + (map(dot) | join(" ")),
                      tooltip: (
                        map(dot + " <b>" + (.name | esc) + "</b> is " + describe)
                        | join("\n")
                      ),
                    }
                  end
              '
            }

            while true; do
              render

              # Podman emits an event whenever a container is created, starts,
              # dies or changes health, so the widget follows `podman compose`
              # right away instead of waiting for the next poll. Events arriving
              # during a render queue up in the pipe rather than getting lost
              timeout 60 podman events --filter type=container --format json 2>/dev/null |
                while read -r _; do
                  # A single compose command emits a burst of events, so wait
                  # for the dust to settle and render the end state once
                  while read -r -t 0.2 _; do :; done
                  render
                done

              # The timeout above doubles as a slow poll, in case the event
              # stream dies; the sleep keeps that from turning into a hot loop
              sleep 1
            done
          '';
          exec-if = "command -v podman";
          return-type = "json";
        };
        "custom/dnd" = {
          exec = pkgs.writeShellScript "waybar-dnd" ''
            set -u
            if ${pkgs.mako}/bin/makoctl mode | grep -q do-not-disturb; then
              echo '{"text": "󰂛", "tooltip": "Do not disturb enabled"}'
            else
              echo ""
            fi
          '';
          signal = 2;
          return-type = "json";
          on-click = "${pkgs.mako}/bin/makoctl mode -r do-not-disturb; pkill -RTMIN+2 waybar";
        };
        "custom/updates" = {
          format = "<span size=\"120%\">{}</span>";
          exec = pkgs.writeShellScript "waybar-updates" ''
            set -u

            current_timestamp=$(timeout 30 nix flake metadata ${config.programs.nh.flake} --json | jq '.locks.nodes.nixpkgs.locked.lastModified') || exit 0
            latest_timestamp=$(timeout 30 nix flake metadata github:NixOS/nixpkgs/nixos-unstable --json | jq '.locked.lastModified') || exit 0

            if [ "$latest_timestamp" -le "$current_timestamp" ]; then
              echo ""
              exit 0
            fi

            echo "{\"text\": \"󱄅\", \"tooltip\": \"Updates available\"}"
          '';
          exec-if = "test -d ${config.programs.nh.flake}";
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
          color: #${theme.colors.foreground};
          border: 1px solid #${theme.colors.foreground};
        }

        #workspaces button {
          margin: 4px;
          padding: 0 8px;
          border: none;
          border-radius: 9999px;
          background: transparent;
          box-shadow: none;
          color: #${theme.colors.foreground};
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
        #custom-containers,
        #custom-dnd,
        #custom-agents {
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

        #custom-dnd {
          padding-right: 17px;
          color: #${theme.colors.warning};
          font-weight: bold;
        }

        #privacy,
        #battery.critical {
          color: #${theme.colors.danger};
          font-weight: bold;
        }
      '';
  };
}
