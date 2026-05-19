{
  pkgs,
  inputs,
  config,
  ...
}:

{
  programs.firefox = {
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    enable = true;
    policies = {
      ExtensionSettings = {
        "{cebd391d-f568-473f-bb6e-698d08ec81ec}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4569798/tokyo_night_dark_theme-2.7.xpi";
          private_browsing = true;
        };
        "adguardadblocker@adguard.com" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/adguard-adblocker/latest.xpi";
          private_browsing = true;
          default_area = "navbar";
        };
        "jid1-wC71d7poAZYEGA@jetpack" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/3918715/ddict-4.4.1.xpi";
          default_area = "navbar";
        };
      };
    };
    profiles.default = {
      search.force = true;
      settings = {
        "extensions.pocket.enabled" = false;
        "dom.security.https_only_mode" = false;
        "browser.download.panel.shown" = true;
        "identity.fxaccounts.enabled" = false;
        "signon.rememberSignons" = false;
        "browser.theme.toolbar-theme" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = "";
    };
  };
}
