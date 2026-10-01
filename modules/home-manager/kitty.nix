{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.within.kitty;
in
{
  options.within.kitty.enable = mkEnableOption "Enables Within's Kitty config";

  config = mkIf cfg.enable {
    home.file = {
      ".config/kitty/kitty.conf" = {
        source = ../../config/kitty/kitty.conf;
      };

      ".config/kitty/themes/catppuccin" = {
        source = ../../config/kitty/themes/catppuccin;
      };
    };
  };
}
