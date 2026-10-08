{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.within.tmux;
  statusTheme =
    if cfg.nerdFont then
      builtins.readFile ../../config/tmux/status-nerdfont.conf
    else
      builtins.readFile ../../config/tmux/status-minimal.conf;
in
{
  options.within.tmux = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables Within's Tmux configuration";
    };
    nerdFont = mkOption {
      type = types.bool;
      default = true;
      description = "Use Nerd Font icons in status bar (false for standard UTF-8)";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      plugins = [
        pkgs.tmuxPlugins.vim-tmux-navigator
      ];
      extraConfig = ''
        ${builtins.readFile ../../config/tmux/tmux.base.conf}
        ${statusTheme}
      '';
    };
  };
}
