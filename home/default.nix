{ config, ... }:

{
  imports = [
    ./window-manager.nix
    ./terminal.nix
    ./editor.nix
    ./tools.nix
    ./upgrade-diff.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  home.username = "lena";
  home.homeDirectory = "/home/${config.home.username}";

  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
