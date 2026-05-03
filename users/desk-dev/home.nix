{ config, pkgs, ... }:

{
  imports = [
    ./../../modules/home-manager/default.nix
    ./../../modules/home-manager/niri.nix
    ./../../modules/home-manager/firefox.nix
    ./../../modules/home-manager/zathura.nix
    ./../../modules/home-manager/neovim.nix
    ./../../modules/home-manager/vscode.nix
    ./../../modules/home-manager/noctalia.nix
    ./../../modules/home-manager/satty.nix
    ./../../modules/home-manager/mpv.nix
    # ./../../modules/home-manager/jetbrains.nix
    ./lang.nix
    ./scripts.nix
    ./mimetypes.nix
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
  home.stateVersion = "26.05";

  within.zsh.enable = true;
  within.ghostty.enable = true;
  within.neovim.enable = true;
  within.alacritty.enable = true;
  within.niri.enable = true;
  within.noctalia.enable = true;
  within.satty.enable = true;
  within.mpv.enable = true;

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
    file
    winboat # windows virtualization
    freerdp # for winboat
    jetbrains-toolbox
    libreoffice-qt
    wl-clipboard
    jq
    slurp
    grim
    opencode
  ];

  xdg.userDirs.enable = true;

  xdg.userDirs.createDirectories = true;
  # xdg.userDirs.setSessionVariables = true;
  xdg.userDirs.pictures = "Pictures";
  xdg.userDirs.download = "Downloads";
  xdg.userDirs.documents = "Documents";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
