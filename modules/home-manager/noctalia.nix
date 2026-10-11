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
    home.file.".config/noctalia/config.toml".source = ../../config/noctalia/config.toml;

    home.file.".config/noctalia/templates/labwc.conf".source =
      ../../config/noctalia/templates/labwc.conf;

    home.file.".config/noctalia/templates/niri.conf".source = ../../config/noctalia/templates/niri.conf;

    home.file.".config/noctalia/templates/zathura-dark.theme".source =
      ../../config/noctalia/templates/zathura-dark.theme;

    home.file.".config/noctalia/templates/zathura-light.theme".source =
      ../../config/noctalia/templates/zathura-light.theme;
  };
}
