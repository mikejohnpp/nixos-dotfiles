{ pkgs, ... }:
{
  home.packages = [
    pkgs.poppler-utils # pdfinfo/pdftotext for dot-books preview
    (pkgs.writeShellScriptBin "dot-screenshot" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ../../bin/dot-screenshot.sh}
    '')
    (pkgs.writeShellScriptBin "dot-present" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ../../bin/dot-present.sh}
    '')
    (pkgs.writeShellScriptBin "dot-tmux-stat" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ../../bin/dot-tmux-stat.sh}
    '')
    (pkgs.writeShellScriptBin "dot-tmux-tasks" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ../../bin/dot-tmux-tasks.sh}
    '')
    (pkgs.writeShellScriptBin "dot-tmux-let-timer" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ../../bin/dot-tmux-let-timer.sh}
    '')
    (pkgs.writeShellScriptBin "dot-books" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ../../bin/dot-books.sh}
    '')
  ];
}
