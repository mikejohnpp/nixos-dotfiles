{ config, pkgs, ... }:

{
  programs.zathura = {
    enable = true;
    package = pkgs.zathura;

    options = {
      adjust-open = "best-fit";
      pages-per-row = 1;
      first-page-column = "1:1";
      page-padding = 1;
      page-cache-size = 64;
      scroll-page-aware = true;
      scroll-full-overlap = 0.01;
      scroll-step = 100;
      zoom-step = 10;
      zoom-min = 10;
      zoom-max = 1000;
      smooth-scroll = true;
      font = "monospace 11";
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      statusbar-home-tilde = true;
      window-title-basename = true;
      selection-clipboard = "clipboard";
      database = "sqlite";
      render-loading = true;
      recolor = true;
      recolor-keephue = true;
      recolor-reverse-video = true;
    };

    mappings = {
      r = "recolor";
      D = "toggle_page_mode";
      i = "toggle_statusbar";
    };

    extraConfig = ''
      include ${config.xdg.configHome}/zathura/themes/fallback.theme
      include ${config.xdg.configHome}/zathura/themes/noctalia.theme
    '';
  };

  xdg.configFile."zathura/themes/fallback.theme".source =
    ../../config/noctalia/templates/zathura-dark.theme;
}
