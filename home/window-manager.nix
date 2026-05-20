{
  config,
  pkgs,
  theme,
  ...
}:

let
  # Mango's config parser reads each key and value into a 256 byte buffer and
  # silently truncates anything longer, which quietly breaks lines built from
  # several store paths. Keep the config file short by putting those commands
  # in scripts and only referencing the script path.
  startSession = pkgs.writeShellScript "mango-start-session" ''
    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
      DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE \
      NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE
    ${pkgs.systemd}/bin/systemctl --user start mango-session.target

    # Retried until the awww daemon the target just started takes connections
    for _ in $(${pkgs.coreutils}/bin/seq 10); do
      ${pkgs.awww}/bin/awww img ${config.xdg.dataHome}/wallpapers/bespinian.png && break
      ${pkgs.coreutils}/bin/sleep 1
    done
  '';

  screenshotDir = "${config.xdg.userDirs.pictures}/Screenshots";

  screenshot = pkgs.writeShellScript "screenshot" ''
    ${pkgs.coreutils}/bin/mkdir -p "${screenshotDir}"
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" \
      "${screenshotDir}/$(${pkgs.coreutils}/bin/date +'%F-%H%M%S').png"
  '';

  screenshotAnnotated = pkgs.writeShellScript "screenshot-annotated" ''
    ${pkgs.coreutils}/bin/mkdir -p "${screenshotDir}"
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" -t ppm - \
      | ${pkgs.satty}/bin/satty --filename - \
        --output-filename "${screenshotDir}/$(${pkgs.coreutils}/bin/date +'%F-%H%M%S').png"
  '';

  # Swaylock cannot blur its background the way Hyprlock did, so the blurred
  # variant of the wallpaper is baked at build time instead
  blurredWallpaper =
    pkgs.runCommand "bespinian-blurred.png" { nativeBuildInputs = [ pkgs.imagemagick ]; }
      ''
        magick ${./wallpapers/bespinian.png} -blur 0x32 $out
      '';
in

{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "${pkgs.kitty}/bin/kitty";
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

    # Screen lock
    swaylock = {
      enable = true;
      settings = {
        image = "${config.xdg.dataHome}/wallpapers/bespinian-blurred.png";
        font = theme.font;

        # Only the ring reacts to the entered password, so the indicator stays
        # a flat disc on the wallpaper like Hyprlock's input field did
        inside-color = theme.colors.background;
        inside-clear-color = theme.colors.background;
        inside-ver-color = theme.colors.background;
        inside-wrong-color = theme.colors.background;
        ring-color = theme.colors.background;
        ring-clear-color = theme.colors.background;
        ring-ver-color = theme.colors.warning;
        ring-wrong-color = theme.colors.danger;
        text-color = theme.colors.foreground;
        text-clear-color = theme.colors.foreground;
        text-ver-color = theme.colors.foreground;
        text-wrong-color = theme.colors.foreground;
        key-hl-color = theme.colors.primary;
        bs-hl-color = theme.colors.danger;
        line-uses-inside = true;
        separator-color = theme.colors.background;
      };
    };
  };

  services = {
    # Background image
    awww.enable = true;

    # Idle manager
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 600;
          command = "${pkgs.swaylock}/bin/swaylock --daemonize";
        }
        {
          timeout = 900;
          command = "${pkgs.wlopm}/bin/wlopm --off '*'";
          resumeCommand = "${pkgs.wlopm}/bin/wlopm --on '*'";
        }
        {
          timeout = 1200;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = {
        "before-sleep" = "${pkgs.swaylock}/bin/swaylock --daemonize";
        "lock" = "${pkgs.swaylock}/bin/swaylock --daemonize";
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

  # Window manager
  wayland.systemd.target = "mango-session.target";
  xdg.configFile = {
    "mango/config.conf".text = # ini
      ''
        # Hand the session over to systemd so the user services (Waybar, Mako,
        # swayidle, awww, ...) start, then set the background image
        exec-once=${startSession}

        # Monitors
        monitorrule=name:^eDP-1$,scale:1.5
        xwayland_ignore_scale=1

        # Look and feel
        borderpx=2
        border_radius=0
        no_border_when_single=1
        smartgaps=1
        gappih=0
        gappiv=0
        gappoh=0
        gappov=0
        rootcolor=0x${theme.colors.background}ff
        bordercolor=0x${theme.colors.backgroundLight}ff
        focuscolor=0x${theme.colors.primary}ff
        urgentcolor=0x${theme.colors.danger}ff
        maximizescreencolor=0x${theme.colors.success}ff
        scratchpadcolor=0x${theme.colors.warning}ff
        globalcolor=0x${theme.colors.primary}ff
        overlaycolor=0x${theme.colors.primary}ff
        cursor_hide_timeout=8

        # Tags
        tag_num=9
        tagrule=id:*,layout_name:dwindle

        # Input
        xkb_rules_options=caps:escape,compose:ralt
        trackpad_natural_scrolling=1

        # Window manager
        bind=SUPER,Tab,view,-1
        bind=SUPER,a,toggleoverview
        bind=SUPER,q,killclient
        bind=SUPER,f,togglefullscreen
        bind=SUPER,v,togglefloating
        bind=SUPER,y,toggleglobal
        bind=SUPER,n,switch_layout
        bind=SUPER,r,reload_config

        # Shortcuts
        bind=SUPER,space,spawn,${pkgs.vicinae}/bin/vicinae vicinae://toggle
        bind=SUPER,Return,spawn,${pkgs.kitty}/bin/kitty
        bind=SUPER,w,spawn,${pkgs.brave-origin}/bin/brave-origin
        bind=SUPER,c,spawn,${pkgs.vicinae}/bin/vicinae vicinae://launch/clipboard/history
        bind=SUPER,e,spawn,${pkgs.vicinae}/bin/vicinae vicinae://launch/core/search-emojis
        bind=SUPER+CTRL,q,spawn,${pkgs.systemd}/bin/loginctl lock-session

        # Screenshots
        bind=NONE,Print,spawn,${screenshot}
        bind=SHIFT,Print,spawn,${screenshotAnnotated}

        # Move window focus
        bind=SUPER,h,focusdir,left
        bind=SUPER,j,focusdir,down
        bind=SUPER,k,focusdir,up
        bind=SUPER,l,focusdir,right

        # Move window
        bind=SUPER+SHIFT,h,exchange_client,left
        bind=SUPER+SHIFT,j,exchange_client,down
        bind=SUPER+SHIFT,k,exchange_client,up
        bind=SUPER+SHIFT,l,exchange_client,right

        # Tags
        bind=SUPER,1,view,1
        bind=SUPER,2,view,2
        bind=SUPER,3,view,3
        bind=SUPER,4,view,4
        bind=SUPER,5,view,5
        bind=SUPER,6,view,6
        bind=SUPER,7,view,7
        bind=SUPER,8,view,8
        bind=SUPER,9,view,9
        bind=SUPER,bracketleft,viewtoleft
        bind=SUPER,bracketright,viewtoright
        bind=SUPER,s,toggle_scratchpad

        bind=SUPER+SHIFT,1,tag,1
        bind=SUPER+SHIFT,2,tag,2
        bind=SUPER+SHIFT,3,tag,3
        bind=SUPER+SHIFT,4,tag,4
        bind=SUPER+SHIFT,5,tag,5
        bind=SUPER+SHIFT,6,tag,6
        bind=SUPER+SHIFT,7,tag,7
        bind=SUPER+SHIFT,8,tag,8
        bind=SUPER+SHIFT,9,tag,9
        bind=SUPER+SHIFT,bracketleft,tagtoleft
        bind=SUPER+SHIFT,bracketright,tagtoright
        bind=SUPER+SHIFT,s,minimized

        # Monitors
        bind=SUPER+CTRL,bracketleft,focusmon,left
        bind=SUPER+CTRL,bracketright,focusmon,right
        bind=SUPER+CTRL+SHIFT,bracketleft,tagmon,left
        bind=SUPER+CTRL+SHIFT,bracketright,tagmon,right

        # Media keys
        bindl=NONE,XF86AudioPlay,spawn,${pkgs.swayosd}/bin/swayosd-client --playerctl play-pause
        bindl=NONE,XF86AudioNext,spawn,${pkgs.swayosd}/bin/swayosd-client --playerctl next
        bindl=NONE,XF86AudioPrev,spawn,${pkgs.swayosd}/bin/swayosd-client --playerctl previous
        bindl=NONE,XF86AudioMute,spawn,${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle
        bindl=NONE,XF86AudioMicMute,spawn,${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle
        bindl=NONE,XF86AudioRaiseVolume,spawn,${pkgs.swayosd}/bin/swayosd-client --output-volume raise --max-volume 120
        bindl=NONE,XF86AudioLowerVolume,spawn,${pkgs.swayosd}/bin/swayosd-client --output-volume lower --max-volume 120
        bindl=NONE,XF86MonBrightnessUp,spawn,${pkgs.swayosd}/bin/swayosd-client --brightness raise
        bindl=NONE,XF86MonBrightnessDown,spawn,${pkgs.swayosd}/bin/swayosd-client --brightness lower

        # Mouse
        mousebind=SUPER,btn_left,moveresize,curmove
        mousebind=SUPER,btn_right,moveresize,curresize
        axisbind=SUPER,UP,viewtoleft_have_client
        axisbind=SUPER,DOWN,viewtoright_have_client

        # Touchpad gestures
        gesturebind=NONE,left,3,viewtoright_have_client
        gesturebind=NONE,right,3,viewtoleft_have_client
      '';
  };

  # Session target the user services attach to, started by mango's exec-once
  systemd.user.targets.mango-session = {
    Unit = {
      Description = "mango compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  # Wallpaper
  xdg.dataFile = {
    "wallpapers/bespinian.png".source = ./wallpapers/bespinian.png;
    "wallpapers/bespinian-blurred.png".source = blurredWallpaper;
  };
}
