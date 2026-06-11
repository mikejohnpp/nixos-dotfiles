{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

with lib;

let
  cfg = config.within.neovim;
  oldPkgs = import inputs.nixpkgs-neovim012 {
    system = pkgs.system;
  };
in
{
  options.within.neovim.enable = mkEnableOption "Enables Within's Neovim config";

  config = mkIf cfg.enable {

    programs.neovim = {
      package = oldPkgs.neovim-unwrapped;
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = [
        # pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];
      extraPackages = [
      ];
    };
    home.file = {
      ".config/nvim" = {
        source = ../../config/neovim-minimal;
        recursive = true;
      };
    };
  };
}
