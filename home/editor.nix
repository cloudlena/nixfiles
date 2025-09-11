{ pkgs, theme, ... }:

let
  prettierFormatter = parser: {
    command = "${pkgs.prettier}/bin/prettier";
    args = [
      "--parser"
      parser
    ];
  };
in
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = theme.slug;
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
          formatter = prettierFormatter "css";
        }
        {
          name = "html";
          formatter = prettierFormatter "html";
        }
        {
          name = "javascript";
          auto-format = true;
          formatter = prettierFormatter "typescript";
        }
        {
          name = "json";
          formatter = prettierFormatter "json";
        }
        {
          name = "markdown";
          language-servers = [
            "marksman"
            "markdown-oxide"
            "harper-ls"
          ];
          auto-format = true;
          formatter = prettierFormatter "markdown";
        }
        {
          name = "nix";
          auto-format = true;
        }
        {
          name = "python";
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
          formatter = prettierFormatter "svelte";
        }
        {
          name = "astro";
          auto-format = true;
          formatter = prettierFormatter "astro";
        }
        {
          name = "toml";
          auto-format = true;
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = prettierFormatter "typescript";
        }
        {
          name = "yaml";
          auto-format = true;
          formatter = prettierFormatter "yaml";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    # Language servers
    astro-language-server
    bash-language-server
    docker-compose-language-service
    dockerfile-language-server
    golangci-lint-langserver
    gopls
    harper
    marksman
    nixd
    ruff
    rust-analyzer
    svelte-language-server
    tombi
    terraform-ls
    ty
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
