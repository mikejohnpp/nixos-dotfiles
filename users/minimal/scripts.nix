{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "dot-tmux-stat" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ../../bin/dot-tmux-stat.sh}
    '')
  ];
}
