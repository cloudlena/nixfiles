{ config, pkgs, ... }:

{
  home.activation.report-changes = config.lib.dag.entryAnywhere ''
    ${pkgs.nix}/bin/nix store diff-closures "$oldGenPath" "$newGenPath"
  '';
}
