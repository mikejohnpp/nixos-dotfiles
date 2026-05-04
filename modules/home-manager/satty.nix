{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.within.satty;
in
{
  options.within.satty.enable = mkEnableOption "Enables Within's satty config";

  config = mkIf cfg.enable {
    programs.satty.enable = true;
    home.file = {
      ".config/satty" = {
        source = ./../../config/satty;
      };
    };
  };
}
