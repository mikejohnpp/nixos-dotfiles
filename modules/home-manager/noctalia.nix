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
  };
}
