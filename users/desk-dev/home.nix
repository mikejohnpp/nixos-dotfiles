{ config, pkgs, ... }:

{
  imports = [
    ./../../modules/home-manager/default.nix
    ./../../modules/home-manager/niri.nix
    ./../../modules/home-manager/firefox.nix
    ./../../modules/home-manager/zathura.nix
    ./../../modules/home-manager/neovim.nix
    ./../../modules/home-manager/noctalia.nix
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
  within.ghostty.enable = true;
  within.neovim.enable = true;
  within.alacritty.enable = true;
  within.niri.enable = true;
  within.noctalia.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    ripgrep
    nil
    nixpkgs-fmt
    alacritty
    ghostty
    fastfetch
    lazygit
    feh
    unzip
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
