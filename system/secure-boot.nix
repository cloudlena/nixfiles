{ pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = pkgs.lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
