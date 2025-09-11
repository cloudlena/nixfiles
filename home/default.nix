{ config, ... }:

{
  imports = [
    ./window-manager.nix
    ./status-bar.nix
    ./terminal.nix
    ./shell.nix
    ./editor.nix
    ./tools.nix
  ];

  # Pass theme to all imported modules
  _module.args.theme = import ./theme.nix;

  home.username = "lena";
  home.homeDirectory = "/home/${config.home.username}";

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
