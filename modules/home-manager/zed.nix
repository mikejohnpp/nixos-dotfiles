{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.within.zed;
in
{
  options.within.zed.enable = mkEnableOption "Enables Within's Zed config";

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      package = pkgs.zed-editor.fhsWithPackages (
        ps: with ps; [
          glibc.dev
        ]
      );

      mutableUserSettings = true;
      mutableUserKeymaps = true;
      mutableUserTasks = true;
      mutableUserDebug = true;

      extensions = [
        "nix"
        "lua"
        "java"
        "toml"
        "html"
        "php"
        "catppuccin"
        "vague"
        "everforest"
      ];

      extraPackages = with pkgs; [
        nil
        nixfmt
        lua-language-server
        stylua
        basedpyright
        pyright
        ruff
        vscode-langservers-extracted
        vscode-json-languageserver
        eslint_d
        prettierd
        clang-tools
        ccls
        direnv
        nix-direnv
        devenv
        ripgrep
        lazygit
        gh
      ];

      userSettings = lib.importJSON ../../config/zed/settings.json;
      userKeymaps = lib.importJSON ../../config/zed/keymap.json;
      userTasks = lib.importJSON ../../config/zed/tasks.json;

      themes = {
        neobones = ../../config/zed/themes/neobones.json;
      };
    };
  };
}
