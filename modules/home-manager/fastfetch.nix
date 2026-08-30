{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.within.fastfetch;
in
{
  options.within.fastfetch.enable = mkEnableOption "Enables Within's fastfetch config";

  config = mkIf cfg.enable {
    home.file = {
      ".config/fastfetch/config.jsonc" = {
        source = ./../../config/fastfetch/config.jsonc;
      };
    };
  };
}
