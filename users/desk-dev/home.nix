{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./../../modules/home-manager/default.nix
    ./../../modules/home-manager/niri.nix
    ./../../modules/home-manager/labwc.nix
    ./../../modules/home-manager/firefox.nix
    ./../../modules/home-manager/zathura.nix
    ./../../modules/home-manager/neovim.nix
    ./../../modules/home-manager/vscode.nix
    ./../../modules/home-manager/noctalia.nix
    ./../../modules/home-manager/satty.nix
    ./../../modules/home-manager/mpv.nix
    ./../../modules/home-manager/fastfetch.nix
    # ./../../modules/home-manager/vicinae.nix
    ./../../modules/home-manager/zoxide.nix
    ./../../modules/home-manager/kitty.nix
    # ./../../modules/home-manager/jetbrains.nix
    ./lang.nix
    ./scripts.nix
    ./mimetypes.nix
  ];

  home.username = "mikejohnp";
  home.homeDirectory = "/home/mikejohnp";
  home.stateVersion = "26.05";

  home.pointerCursor = {
    enable = true;
    name = "breeze_cursors";
    package = pkgs.kdePackages.breeze;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "catppuccin-mocha-mauve-standard";
      icon-theme = "Papirus-Dark";
      cursor-theme = "breeze_cursors";
      font-name = "Adwaita Sans 10";
      color-scheme = "prefer-dark";
    };
  };

  within.git.enable = true;
  within.zsh.enable = true;
  within.ghostty.enable = true;
  within.neovim.enable = true;
  within.alacritty.enable = true;
  within.niri.enable = true;
  within.labwc.enable = true;
  within.noctalia.enable = true;
  within.satty.enable = true;
  within.mpv.enable = true;
  within.zoxide.enable = true;
  within.fastfetch.enable = true;
  within.kitty.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "electron-40.10.5" ];
  };

  home.packages = with pkgs; [
    pciutils
    gh
    fd
    hurl
    ripgrep
    btop
    curl # tmux status bar weather
    nil
    nixpkgs-fmt
    alacritty
    ghostty
    kitty
    fastfetch
    lazygit
    feh
    unzip
    file
    alacritty
    antigravity-ide-fhs
    winboat # windows virtualization
    freerdp # for winboat
    jetbrains-toolbox
    libreoffice-qt
    wl-clipboard
    peazip
    jq
    slurp
    grim
    neovide
    wl-mirror
    kanshi
    gnome-software
    wf-recorder
    devenv
    redis
    bindfs
    kdePackages.breeze
    kdePackages.qtsvg
    kdePackages.dolphin
    kdePackages.qtmultimedia
    kdePackages.plasma-integration
  ];

  xdg.userDirs.enable = true;

  xdg.userDirs.createDirectories = true;
  xdg.userDirs.setSessionVariables = true;
  xdg.userDirs.pictures = "Pictures";
  xdg.userDirs.download = "Downloads";
  xdg.userDirs.documents = "Documents";
  xdg.userDirs.projects = "Projects";
  xdg.userDirs.videos = "Videos";

  xdg.configFile."kdeglobals".text =
    builtins.readFile "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";

  home.sessionVariables = {
    EDITOR = "nvim";
    XCURSOR_THEME = "breeze_cursors";
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORMTHEME = "kde";

    XDG_CONFIG_HOME = "$HOME/.config";
  };

  home.file = {
    "bg" = {
      source = ../../config/bg;
      recursive = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
