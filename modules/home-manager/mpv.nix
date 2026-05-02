{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.within.mpv;
in
{
  options.within.mpv.enable = mkEnableOption "Enables Within's mpv config";

  config = mkIf cfg.enable {
    programs.mpv.enable = true;

    home.file = {
      ".config/mpv" = {
        source = ./../../config/mpv;
      };
    };
  };
}
