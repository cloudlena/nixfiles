{ config, pkgs, ... }:

{
  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    a = "${pkgs.claude-code}/bin/claude --dangerously-skip-permissions";
    e = "${pkgs.helix}/bin/hx";
    f = "${pkgs.yazi}/bin/yazi";
    g = "${pkgs.gitui}/bin/gitui";
    m = "${pkgs.bottom}/bin/btm";
    o = "${pkgs.xdg-utils}/bin/xdg-open";
    t = "${pkgs.taskwarrior3}/bin/task";
    do-not-disturb = "${pkgs.mako}/bin/makoctl mode -a do-not-disturb && pkill -RTMIN+2 waybar";
    do-disturb = "${pkgs.mako}/bin/makoctl mode -r do-not-disturb && pkill -RTMIN+2 waybar";
  };

  programs = {
    # Shell
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      completionInit = # shell
        ''
          autoload -Uz compinit && compinit
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        '';
      defaultKeymap = "viins";
      history.ignoreAllDups = true;
      historySubstringSearch = {
        enable = true;
        searchDownKey = "^N";
        searchUpKey = "^P";
      };
      localVariables = {
        HISTORY_SUBSTRING_SEARCH_PREFIXED = "true";
      };
      loginExtra = # shell
        ''
          if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec ${pkgs.hyprland}/bin/start-hyprland
          fi
        '';
      initContent = # shell
        ''
          source ${config.xdg.configHome}/zsh/*
          if [[ $(tty) != /dev/tty[0-9] ]]; then
            ${pkgs.krabby}/bin/krabby random 1 --no-title --padding-left 1
          fi
        '';
    };

    # Prompt
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        aws.disabled = true;
        cmd_duration.disabled = true;
        gcloud.disabled = true;
        package.disabled = true;
      };
    };
  };

  # Helper functions
  xdg.configFile = {
    "zsh/functions.zsh".source = pkgs.writeShellScript "shell-functions" ''
      # Create a directory and enter it
      mkcd() {
      	mkdir --parents "$@" && cd "$_" || exit
      }

      # Checkout Git branches or tags using fuzzy search
      fco() {
        local branches branch selected
        branches=$(
          ${pkgs.git}/bin/git --no-pager branch --sort=-committerdate
          ${pkgs.git}/bin/git --no-pager branch -r --sort=-committerdate | grep -v ' -> ' | while read -r rb; do
            local_name=$(echo "$rb" | awk '{n=$1; sub(/[^/]*\//, "", n); print n}')
            if ! ${pkgs.git}/bin/git --no-pager branch --list "$local_name" | grep -q .; then
              echo "  $local_name"
            fi
          done
        ) || return
        branch=$(echo "$branches" | ${pkgs.fzf}/bin/fzf +m) || return
        selected=$(echo "$branch" | awk '{print ($1 == "*") ? $2 : $1}')
        ${pkgs.git}/bin/git switch "$selected"
      }

      # Update system
      pacu() {
        (cd ${config.programs.nh.flake} &&
        ${pkgs.gnumake}/bin/make update &&
        ${pkgs.gnumake}/bin/make system &&
        ${pkgs.gnumake}/bin/make home) &&
        fwupdmgr refresh &&
        fwupdmgr update
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
      	if [ -e uv.lock ]; then
      		printf "Updating Python dependencies for %s...\n\n" "''${PWD##*/}"
      		uv sync --upgrade
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
