{ config, pkgs, ... }:

{
  imports = [
    ./../../modules/home-manager/neovim-minimal.nix
    ./../../modules/home-manager/tmux.nix
    ./../../modules/home-manager/ghostty.nix
    ./../../modules/home-manager/git.nix
    ./../../modules/home-manager/zsh.nix
    ./../../modules/home-manager/fastfetch.nix
    ./../../modules/home-manager/zoxide.nix
    ./lang.nix
    ./scripts.nix
  ];

  home.username = "mikejohnp";
  home.homeDirectory = "/home/mikejohnp";

  within.neovim.enable = true;
  within.zsh.enable = true;
  within.git.enable = true;
  within.ghostty.enable = true;
  within.fastfetch.enable = true;
  within.zoxide.enable = true;
  within.tmux.enable = true;
  within.tmux.nerdFont = false;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    ghostty
    alacritty
    ripgrep
    fastfetch
    lazygit
    unzip
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
