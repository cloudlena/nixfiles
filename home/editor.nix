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
            command = "${pkgs.prettier}/bin/prettier";
            args = [
              "--parser"
              "css"
            ];
          };
        }
        {
          name = "html";
          formatter = {
            command = "${pkgs.prettier}/bin/prettier";
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
            command = "${pkgs.prettier}/bin/prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }
        {
          name = "json";
          formatter = {
            command = "${pkgs.prettier}/bin/prettier";
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
            "markdown-oxide"
            "harper-ls"
          ];
          auto-format = true;
          formatter = {
            command = "${pkgs.prettier}/bin/prettier";
            args = [
              "--parser"
              "markdown"
            ];
          };
        }
        {
          name = "nix";
          auto-format = true;
        }
        {
          name = "python";
          language-servers = [
            "ty"
            "ruff"
            "jedi-language-server"
            "pylsp"
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
            command = "${pkgs.prettier}/bin/prettier";
            args = [
              "--parser"
              "svelte"
            ];
          };
        }
        {
          name = "toml";
          auto-format = true;
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = {
            command = "${pkgs.prettier}/bin/prettier";
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
            command = "${pkgs.prettier}/bin/prettier";
            args = [
              "--parser"
              "yaml"
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
    nixfmt
    prettier
    rustfmt
  ];
}
