{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "tokyonight";
      editor = {
        line-number = "relative";
        cursor-shape.insert = "bar";
        file-picker.hidden = false;
        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning";
      };
    };
    languages = {
      language-server = {
        gopls = {
          config."formatting.gofumpt" = true;
        };
        harper-ls = {
          command = "harper-ls";
          args = [ "--stdio" ];
        };
      };
      language = [
        {
          name = "bash";
          auto-format = true;
          formatter = {
            command = "${pkgs.shfmt}/bin/shfmt";
          };
        }
        {
          name = "css";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "css"
            ];
          };
        }
        {
          name = "html";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "html"
            ];
          };
        }
        {
          name = "javascript";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }
        {
          name = "json";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "json"
            ];
          };
        }
        {
          name = "markdown";
          language-servers = [
            "marksman"
            "harper-ls"
          ];
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "markdown"
            ];
          };
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          };
        }
        {
          name = "python";
          language-servers = [
            "ruff"
            "pyright"
          ];
          auto-format = true;
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = [
              "format"
              "-"
            ];
          };
        }
        {
          name = "svelte";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "svelte"
            ];
          };
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }
        {
          name = "yaml";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "yaml"
            ];
          };
        }
        {
          name = "toml";
          auto-format = true;
          formatter = {
            command = "${pkgs.taplo}/bin/taplo";
            args = [
              "fmt"
              "-"
            ];
          };
        }
      ];
    };
  };

  home.packages = with pkgs; [
    # Language servers
    bash-language-server
    docker-compose-language-service
    dockerfile-language-server-nodejs
    golangci-lint-langserver
    gopls
    harper
    marksman
    nixd
    pyright
    ruff
    rust-analyzer
    svelte-language-server
    taplo
    terraform-ls
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server

    # Debuggers
    delve
    lldb

    # Formatters
    nodePackages.prettier
    rustfmt
  ];
}
