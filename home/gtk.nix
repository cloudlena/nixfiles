{
  pkgs,
  lib,
  theme,
  ...
}:

let
  # adw-gtk3 (GTK 3) and libadwaita (GTK 4) resolve these named colors at draw
  # time, so redefining them recolors the stock themes. Names they derive from
  # these (theme_bg_color, borders, insensitive_fg_color, ...) follow along.
  namedColors = with theme.colors; {
    window_bg_color = background;
    window_fg_color = foreground;
    view_bg_color = backgroundDark;
    view_fg_color = foreground;
    headerbar_bg_color = backgroundDark;
    headerbar_fg_color = foreground;
    sidebar_bg_color = backgroundDark;
    sidebar_fg_color = foreground;
    secondary_sidebar_bg_color = backgroundDark;
    secondary_sidebar_fg_color = foreground;
    popover_bg_color = background;
    popover_fg_color = foreground;
    dialog_bg_color = background;
    dialog_fg_color = foreground;
    card_bg_color = backgroundLight;
    card_fg_color = foreground;
    thumbnail_bg_color = backgroundLight;
    thumbnail_fg_color = foreground;
    border_color = backgroundLight;

    # Adwaita greys out unfocused windows; keep them flat instead.
    headerbar_backdrop_color = backgroundDark;
    sidebar_backdrop_color = backgroundDark;
    secondary_sidebar_backdrop_color = backgroundDark;

    accent_color = primary;
    accent_bg_color = primary;
    accent_fg_color = backgroundDark;
    destructive_color = danger;
    destructive_bg_color = danger;
    destructive_fg_color = backgroundDark;
    error_color = danger;
    error_bg_color = danger;
    error_fg_color = backgroundDark;
    success_color = success;
    success_bg_color = success;
    success_fg_color = backgroundDark;
    warning_color = warning;
    warning_bg_color = warning;
    warning_fg_color = backgroundDark;
  };

  render =
    format:
    lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: format name "#${value}") namedColors);

  defineColors = render (name: value: "@define-color ${name} ${value};");

  # GTK 4 widgets read custom properties, but apps still styling themselves with
  # the old @define-color names get libadwaita's unthemed defaults, so emit both.
  gtk4Css = ''
    :root {
    ${render (name: value: "  --${lib.replaceStrings [ "_" ] [ "-" ] name}: ${value};")}
    }

    ${defineColors}
  '';
in
{
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    font = {
      name = theme.font;
      package = pkgs.nerd-fonts.fira-code;
      size = 10;
    };
    iconTheme = {
      name = theme.icons;
      package = pkgs.papirus-icon-theme;
    };
    gtk4.extraCss = gtk4Css;
    gtk3.extraCss = defineColors;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
