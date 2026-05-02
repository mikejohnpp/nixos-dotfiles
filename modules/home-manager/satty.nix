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
    home.packages = [
      pkgs.satty
    ];
    home.file = {
      ".config/satty" = {
        source = ./../../config/satty;
      };
    };
  };
}
