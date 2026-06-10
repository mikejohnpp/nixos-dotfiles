{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.within.zoxide;
in
{
  options.within.zoxide.enable = mkEnableOption "Enables Within's Zoxide config";

  config = mkIf cfg.enable {
    programs.zoxide.enable = true;
    programs.zoxide.enableZshIntegration = true;
    programs.zoxide.options = [
      "--cmd cd"
    ];
  };
}
