{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.within.dolphin;
in
{
  options.within.dolphin.enable = mkEnableOption "Enables Within's minimal Dolphin config (native kde platform theme + Noctalia KColorScheme)";

  config = mkIf cfg.enable {
    # Native kde platform theme: HM auto-installs kio, plasma-integration
    # and systemsettings, and exports QT_QPA_PLATFORMTHEME=kde (+ plugin paths).
    # Verified by screenshot A/B test: vanilla qt6ct leaves Kirigami-based
    # Dolphin light, while kde + Noctalia's kdeglobals follows the dark scheme.
    # NOTE: do NOT set qt.style.name — that exports QT_STYLE_OVERRIDE which
    # would override the KColorScheme.
    qt = {
      enable = true;
      platformTheme.name = "kde";
    };

    home.packages = with pkgs; [
      kdePackages.dolphin
      kdePackages.breeze
      kdePackages.breeze-icons
    ];

    # niri `environment{}` doesn't propagate to systemd/portal-started apps,
    # so also set it via environment.d (read by PAM/systemd --user).
    # NOTE: kdeglobals is owned by Noctalia's kcolorscheme template
    # (kde-apply-scheme.py) — do NOT manage it here.
    home.file.".config/environment.d/10-qtct.conf".text = ''
      QT_QPA_PLATFORMTHEME=kde
      XDG_MENU_PREFIX=plasma-
    '';
  };
}
