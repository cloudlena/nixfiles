{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "tokyonight";
      editor = {
        line-number = "relative";
        soft-wrap.enable = true;
        cursor-shape.insert = "bar";
        file-picker.hidden = false;
      };
    };
    languages = {
      language = [
        { name = "bash"; auto-format = true; formatter = { command = "shfmt"; }; }
        { name = "css"; formatter = { command = "prettier"; args = [ "--parser" "css" ]; }; }
        { name = "go"; config = { formatting.gofumpt = true; }; }
        { name = "html"; formatter = { command = "prettier"; args = [ "--parser" "html" ]; }; }
        { name = "javascript"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; }; }
        { name = "json"; formatter = { command = "prettier"; args = [ "--parser" "json" ]; }; }
        { name = "markdown"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "markdown" ]; }; }
        { name = "nix"; auto-format = true; formatter = { command = "nixpkgs-fmt"; }; }
        { name = "python"; auto-format = true; formatter = { command = "black"; args = [ "--quiet" "-" ]; }; }
        { name = "svelte"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "svelte" ]; }; }
        { name = "typescript"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; }; }
        { name = "yaml"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "yaml" ]; }; }
      ];
    };
  };

  home.packages = with pkgs; [
    # Language servers
    cmake-language-server
    gopls
    marksman
    nil
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.svelte-language-server
    nodePackages.typescript-language-server
    nodePackages.yaml-language-server
    python311Packages.python-lsp-server
    rust-analyzer
    terraform-ls
    vscode-langservers-extracted

    # Debuggers
    delve
    lldb

    # Linters
    golangci-lint
    shellcheck
    tflint

    # Formatters
    black
    nixpkgs-fmt
    nodePackages.prettier
    shfmt
  ];
}
