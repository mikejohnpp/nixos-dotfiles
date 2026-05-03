{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.tmux = {
    plugins = [
      pkgs.tmuxPlugins.vim-tmux-navigator
    ];
    enable = true;
    extraConfig = builtins.readFile ../../config/tmux/tmux.conf;
  };
}
