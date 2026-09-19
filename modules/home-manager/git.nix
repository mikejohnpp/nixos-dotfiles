{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.within.git;
in
{
  options.within.git.enable = mkEnableOption "Enables Within's git config";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        # pull.rebase = true;
        core.editor = "nvim";
        diff = {
          algorithm = "histogram";
          colorMoved = "default";
          mnemonicPrefix = true;
        };
        merge.conflictStyle = "zdiff3";
      };
    };
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
    programs.lazygit = {
      enable = true;
      settings = {
        git.diffRenderers = [
          {
            command = ''delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"'';
          }
          {
            type = "rawGit";
            nargs = [ "--color-words" ];
            ame = "color-words";
          }
        ];
      };
    };
  };
}
