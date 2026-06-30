{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  services.vicinae = {
    package = pkgs.vicinae;
    enable = true;
    systemd = {
      enable = true;
      autoStart = true; # default: false
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = false;
      font = {
        normal = {
          size = 12;
          family = "JetBrainsMono Nerd Font Mono";
        };
      };
      theme = {
        light = {
          name = "catppuccin-mocha";
          icon_theme = "default";
        };
        dark = {
          name = "catppuccin-mocha";
          icon_theme = "default";
        };
      };
      launcher_window = {
        opacity = 0.9;
      };
    };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      # bluetooth
      # nix
      # power-profile
      # Extension names can be found in the link below, it's just the folder names
    ];
  };
}
