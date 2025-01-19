{ config, pkgs, ... }:

{
  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    a = "${pkgs.fabric-ai}/bin/fabric";
    e = "${pkgs.helix}/bin/hx";
    f = "${pkgs.yazi}/bin/yazi";
    g = "${pkgs.gitui}/bin/gitui";
    m = "${pkgs.bottom}/bin/btm";
    o = "${pkgs.xdg-utils}/bin/xdg-open";
    t = "${pkgs.taskwarrior3}/bin/task";
  };

  programs = {
    # Shell
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      completionInit = ''
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
      loginExtra = ''
        # Start window manager
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec ${pkgs.hyprland}/bin/Hyprland
        fi
      '';
      initExtra = ''
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
        ${pkgs.git}/bin/git checkout $(awk '{print $2}' <<<"$target" )
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
        fwupdmgr refresh
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
