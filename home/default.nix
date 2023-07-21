{ config, ... }:

{
  imports = [
    ./window-manager.nix
    ./terminal.nix
    ./editor.nix
    ./file-manager.nix
    ./tools.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  home.username = "lena";
  home.homeDirectory = "/home/${config.home.username}";

  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
