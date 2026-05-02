{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "dot-screenshot" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ../../bin/dot-screenshot.sh}
    '')
  ];
}
