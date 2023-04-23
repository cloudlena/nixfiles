{ config, pkgs, ... }:

{
  home.username = "lena";
  home.homeDirectory = "/home/lena";

  home.packages = with pkgs; [
    alacritty
  ];

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Enable ZSH
  programs.zsh.enable = true;

  # Enable Git
  programs.git = {
    enable = true;
    userName = "Lena Fuhrimann";
    userEmail = "6780471+cloudlena@users.noreply.github.com";
  };

  # Enable GPG
  services.gpg-agent.enable = true;

  services.swayidle.enable = true;
}
