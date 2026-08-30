{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib;

let
  cfg = config.within.noctalia;
in
{
  options.within.noctalia.enable = mkEnableOption "Enables Within's noctalia config";

  config = mkIf cfg.enable {
    programs.noctalia = {
      enable = true;
    };
    home.file.".config/noctalia/config.toml".source =
      ../../config/noctalia/config.toml;
    # Theme template rendering -> ~/.config/labwc/themerc-override (Noctalia
    # fills in {{colors.*}} placeholders from its current palette).
    home.file.".config/noctalia/templates/labwc.conf".source =
      ../../config/noctalia/templates/labwc.conf;
  };
}
