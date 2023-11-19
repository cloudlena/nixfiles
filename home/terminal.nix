{ config, pkgs, ... }:

{
  home.shellAliases = {
    e = "${pkgs.helix}/bin/hx";
    f = "br";
    g = "${pkgs.gitui}/bin/gitui";
    t = "${pkgs.taskwarrior}/bin/task";
    o = "${pkgs.xdg-utils}/bin/xdg-open";
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

    # Shell
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "viins";
      completionInit = ''
        autoload -Uz compinit && compinit
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      '';
      history.ignoreAllDups = true;
      historySubstringSearch = {
        enable = true;
        searchDownKey = "^N";
        searchUpKey = "^P";
      };
      localVariables = {
        HISTORY_SUBSTRING_SEARCH_PREFIXED = "true";
      };
      loginExtra = ''
        # Start window manager
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec ${pkgs.hyprland}/bin/Hyprland
        fi
      '';
      initExtra = ''
        source ${config.xdg.configHome}/zsh/*
        if [[ $(tty) != /dev/tty[0-9] ]]; then
          if [ -z "$TMUX" ]; then
            exec ${pkgs.tmux}/bin/tmux || exit
          fi
          ${pkgs.krabby}/bin/krabby random 1 --no-title --padding-left 1
        fi
      '';
    };

    # Terminal multiplexer
    tmux = {
      enable = true;
      keyMode = "vi";
      escapeTime = 10;
      terminal = "tmux-256color";
      extraConfig = ''
        # Set correct terminal
        set-option -sa terminal-features ',alacritty:RGB'

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
    "zsh/functions.zsh".source = pkgs.writeShellScript "waybar-tasks" ''
      # Create a directory and enter it
      mkcd() {
      	mkdir --parents "$@" && cd "$_" || exit
      }

      # Checkout Git branches or tags using fuzzy search
      fco() {
        local tags branches target
        branches=$(
          ${pkgs.git}/bin/git --no-pager branch --all \
            --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
            | sed '/^$/d') || return
        tags=$(${pkgs.git}/bin/git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
        target=$(
          (echo "$branches"; echo "$tags") |
          ${pkgs.fzf}/bin/fzf --no-hscroll --no-multi -n 2 \
              --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
        echo "$target"
        ${pkgs.git}/bin/git checkout $(awk '{print $2}' <<<"$target" | sed 's/^[^\/]*\///')
      }

      # Kill any process with fuzzy search
      fkill() {
      	local pid
      	if [ "$UID" != "0" ]; then
      		pid=$(ps -f -u $UID | sed 1d | ${pkgs.fzf}/bin/fzf -m | awk '{print $2}')
      	else
      		pid=$(ps -ef | sed 1d | ${pkgs.fzf}/bin/fzf -m | awk '{print $2}')
      	fi

      	if [ "x$pid" != "x" ]; then
      		echo "$pid" | xargs kill "-''${1:-9}"
      	fi
      }

      # Git commit browser with fuzzy search
      fshow() {
      	${pkgs.git}/bin/git log --graph --color=always \
      		--format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      		${pkgs.fzf}/bin/fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      			--bind "ctrl-m:execute:
                  (grep -o '[a-f0-9]\{7\}' | head -1 |
                  xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                  {}
      FZF-EOF"
      }

      # Update system
      pacu() {
        pushd ${config.home.homeDirectory}/.nixfiles
        ${pkgs.gnumake}/bin/make update
        ${pkgs.gnumake}/bin/make system
        ${pkgs.gnumake}/bin/make home
        popd
        ${pkgs.fwupd}/bin/fwupdmgr refresh
        ${pkgs.fwupd}/bin/fwupdmgr update
      }

      # Update project dependencies
      depu() {
      	# Git submodules
      	if [ -e .gitmodules ]; then
      		printf "Updating Git submodules for %s...\n\n" "''${PWD##*/}"
      		git submodule update --init --remote --rebase --recursive
      	fi

      	# Nix flakes
      	if [ -e flake.nix ]; then
      		printf "Updating Nix flake inputs for %s...\n\n" "''${PWD##*/}"
      		nix flake update
      	fi

      	# npm
      	if [ -e package-lock.json ]; then
      		printf "Updating npm dependencies for %s...\n\n" "''${PWD##*/}"
      		npm update
      		npm outdated
      	fi

      	# Go
      	if [ -e go.mod ]; then
      		printf "Updating Go dependencies for %s...\n\n" "''${PWD##*/}"
      		go get -t -u ./...
      		go mod tidy
      	fi

      	# Rust
      	if [ -e Cargo.toml ]; then
      		printf "Updating Cargo dependencies for %s...\n\n" "''${PWD##*/}"
      		cargo update
      	fi

      	# Python
      	if [ -e poetry.lock ]; then
      		printf "Updating Python dependencies for %s...\n\n" "''${PWD##*/}"
      		poetry update
      		poetry show --outdated
      	fi

      	# OpenTofu
      	if [ -e .terraform.lock.hcl ]; then
      		printf "Updating OpenTofu dependencies for %s...\n\n" "''${PWD##*/}"
      		tofu init -upgrade
      	fi
      }
    '';
  };
}
