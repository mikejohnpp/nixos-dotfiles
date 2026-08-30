{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.within.labwc;
in
{
  options.within.labwc.enable = mkEnableOption "Enables Within's labwc config";

  config = mkIf cfg.enable {
    home.file = {
      # Symlink each file individually (not the whole directory) so that
      # ~/.config/labwc/ stays a real, writable directory. Noctalia generates
      # and writes `<theme-sync>/themerc-override` there at runtime (see
      # config/noctalia), which would fail if labwc were a read-only symlink
      # of the whole config/labwc directory.
      ".config/labwc/rc.xml" = {
        source = ./../../config/labwc/rc.xml;
      };
      ".config/labwc/menu.xml" = {
        source = ./../../config/labwc/menu.xml;
      };
      ".config/labwc/autostart" = {
        source = ./../../config/labwc/autostart;
      };
      ".config/labwc/environment" = {
        source = ./../../config/labwc/environment;
      };
      # NOTE: ~/.config/labwc/themerc-override is intentionally NOT managed
      # here — it is the output of Noctalia's theme template.
    };
  };
}
