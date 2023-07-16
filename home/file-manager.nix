{ pkgs, ... }:

{
  programs.joshuto = {
    enable = true;
    settings = {
      preview.preview_script = "~/.config/joshuto/preview_file.sh";
    };
  };

  home.packages = with pkgs; [
    # File previewers
    chafa
    file
    poppler_utils
  ];

  xdg.configFile = {
    "joshuto/preview_file.sh" = {
      source = ./joshuto/preview_file.sh;
      executable = true;
    };
  };
}
