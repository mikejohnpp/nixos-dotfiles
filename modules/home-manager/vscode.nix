{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.vscode.fhs ];

  home.file = {
    ".config/Code/User/settings.json".source = ../../config/vscode/settings.json;
    ".config/Code/User/keybindings.json".source = ../../config/vscode/keybindings.json;
    ".config/code-flags.conf".source = ../../config/vscode/code-flags.conf;
  };
}
