{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.within.niri;
in
{
  options.within.niri.enable = mkEnableOption "Enables Within's niri config";

  config = mkIf cfg.enable {
    home.file = {
      ".config/niri/config.kdl" = {
        source = ./../../config/niri/config.kdl;
      };
    };
  };
}
