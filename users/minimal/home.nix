{ config, pkgs, ... }:

{
  imports = [
    ./../../modules/home-manager/neovim.nix
    ./../../modules/home-manager/zsh.nix
    ./../../modules/home-manager/tmux.nix
    ./lang.nix
  ];

  home.username = "mikejohnp";
  home.homeDirectory = "/home/mikejohnp";
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "vim";
    };
  };
  home.stateVersion = "25.05";

  within.zsh.enable = true;
  within.neovim.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    ripgrep
    nil
    fastfetch
    feh
    lazygit
    unzip
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
