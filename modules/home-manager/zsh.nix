{
  lib,
  config,
  pkgs,
  commands,
  ...
}:

with lib;

let
  cfg = config.within.zsh;
in
{
  options.within.zsh.enable = mkEnableOption "Enables ZSH Settings";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.bat
      pkgs.ripgrep # grep string telescope
    ];

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
      ];
      enable = true;
      # autosuggestion Configuration Options
      autosuggestion.enable = true;
      autosuggestion.strategy = [
        "history"
        "completion"
      ];
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      history = {
        size = 50000;
        save = 50000;
        path = "${config.xdg.dataHome}/zsh/history";
        append = true;
        expireDuplicatesFirst = true;
        share = true;
      };
      shellAliases = {
        lzd = "lazydocker";
        slzd = "sudo lazydocker";
        lzg = "lazygit";
        slzg = "sudo lazygit";
        ff = "fastfetch";
        ls = "ls -lh -F --color=auto";
      };
    };

    # Starship Configuration Options
    programs.starship.enable = true;
    home.file = {
      ".config/starship.toml" = {
        source = ./../../config/starship/starship.toml;
      };
    };
  };
}
