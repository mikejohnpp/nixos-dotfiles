{ config, pkgs, ... }:

{
  imports = [
    ./../../modules/home-manager/tmux.nix
    ./../../modules/home-manager/default.nix
    ./../../modules/home-manager/neovim.nix
    ./../../modules/home-manager/fastfetch.nix
    ./../../modules/home-manager/ghostty.nix
    ./../../modules/home-manager/zoxide.nix
    ./lang.nix
    ./scripts.nix
  ];

  home.username = "mikejohnp";
  home.homeDirectory = "/home/mikejohnp";

  within.git.enable = true;
  within.zsh.enable = true;
  within.ghostty.enable = true;
  within.neovim.enable = true;
  within.alacritty.enable = true;
  within.zoxide.enable = true;
  within.fastfetch.enable = true;

  programs.zsh.envExtra = ''
    if [ -f /etc/profile.d/nix.sh ]; then
      . /etc/profile.d/nix.sh
    fi
  '';

  programs.zsh.sessionVariables = {
    EDITOR = "nvim";
    TZ = "Asia/Ho_Chi_Minh";
  };

  programs.bash.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    pciutils
    gh
    fd
    hurl
    ripgrep
    btop
    nil
    nixpkgs-fmt
    alacritty
    fastfetch
    lazygit
    unzip
    file
    wl-clipboard
    jq
    devenv
    satty

    # Fonts (mirror of nixos/desk/configuration.nix)
    corefonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-mono
    nerd-fonts.noto
    nerd-fonts.meslo-lg
    adwaita-fonts
  ];

  xdg.userDirs.enable = true;

  fonts.fontconfig.enable = true;

  xdg.userDirs.createDirectories = true;
  xdg.userDirs.setSessionVariables = true;
  xdg.userDirs.pictures = "Pictures";
  xdg.userDirs.download = "Downloads";
  xdg.userDirs.documents = "Documents";
  xdg.userDirs.projects = "Projects";
  xdg.userDirs.videos = "Videos";

  home.sessionVariables = {
    EDITOR = "nvim";
    TZ = "Asia/Ho_Chi_Minh";
  };

  # zsh login (Fedora) doesn't source /etc/profile like bash does, so PATH
  # misses ~/.nix-profile/bin etc. Source it explicitly for zlogin shells.
  home.file.".zprofile" = {
    text = ''
      if [ -f /etc/profile ]; then
        . /etc/profile
      fi
    '';
  };

  home.file = {
    ".config/labwc/rc.xml" = {
      source = ../../config/labwc/rc.xml;
    };
    ".config/labwc/menu.xml" = {
      source = ../../config/labwc/menu.xml;
    };
    ".config/labwc/autostart" = {
      source = ../../config/labwc/autostart;
      executable = true;
    };
    ".config/noctalia/config.toml" = {
      source = ../../config/noctalia/config.toml;
    };
    ".config/noctalia/templates/labwc.conf" = {
      source = ../../config/noctalia/templates/labwc.conf;
    };
    ".config/kanshi/config" = {
      source = ../../config/kanshi/config;
    };
    ".config/mpv" = {
      source = ../../config/mpv;
      recursive = true;
    };
    ".config/satty" = {
      source = ../../config/satty;
      recursive = true;
    };
    "bg" = {
      source = ../../config/bg;
      recursive = true;
    };
  };

  # installers output to these dirs, which are NOT in Fedora's default PATH.
  home.sessionPath = [
    "$HOME/.opencode/bin"
    "$HOME/.local/bin"
  ];

  programs.home-manager.enable = true;

  # Fedora ships ~/.config/user-dirs.dirs already; overwrite with our managed copy.
  xdg.configFile."user-dirs.dirs".force = true;

  home.stateVersion = "26.05";
}
