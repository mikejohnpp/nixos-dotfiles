{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "dot-screenshot" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ../../bin/dot-screenshot.sh}
    '')
    (pkgs.writeShellScriptBin "dot-present" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ../../bin/dot-present.sh}
    '')
  ];
}
