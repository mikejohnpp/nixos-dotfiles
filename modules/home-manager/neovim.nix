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
        pkgs.vscode-json-languageserver
        pkgs.lua-language-server
        pkgs.luajitPackages.jsregexp
        pkgs.nil
        pkgs.eslint_d
        pkgs.prettierd
        pkgs.htmlhint
        # pkgs.gopls
        # pkgs.gofumpt
        pkgs.stylua
        pkgs.nixfmt
        pkgs.basedpyright
        pkgs.pyright
        pkgs.ruff
        pkgs.nixfmt-rfc-style
        # pkgs.zls
        pkgs.ripgrep
        # fix bug lazy-luarocks
        # pkgs.luarocks
        pkgs.lua51Packages.lua
        pkgs.lua51Packages.luarocks
        pkgs.vscode-langservers-extracted
        pkgs.ccls
        # pkgs.asm-lsp
        pkgs.imagemagick
        pkgs.ghostscript
        pkgs.tectonic
        pkgs.tree-sitter
      ];
    };
    home.file = {
      ".config/nvim" = {
        source = ../../config/neovim;
        recursive = true;
      };
    };
  };
}
