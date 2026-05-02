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
    # import the home manager module
    programs.noctalia-shell = {
      enable = true;
      # settings = ./../../config/noctalia/settings.json;
      # colors = ./../../config/noctalia/colors.json;
    };

    home.file = {
      ".config/noctalia" = {
        source = ./../../config/noctalia;
      };
    };
  };
}
