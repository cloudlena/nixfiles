{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.sbctl
  ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
