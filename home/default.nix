{ config, ... }:

{
  imports = [
    ./window-manager.nix
    ./terminal.nix
    ./shell.nix
    ./editor.nix
    ./tools.nix
    ./upgrade-diff.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "lena";
  home.homeDirectory = "/home/${config.home.username}";

  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
