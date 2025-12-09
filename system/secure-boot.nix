{ pkgs, lib, ... }:

{
  environment.systemPackages = [
    pkgs.sbctl
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
