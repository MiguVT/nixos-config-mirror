{ pkgs, ... }:

let
  betterfox = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/yokoffing/Betterfox/8e415d1633f10fe0192d9c938e4ca2628eeec9f9/user.js";
    # Update this hash if the fetched content changes
    hash = "sha256-yelDvg0IKbd0xv4QfaZVca+Io6J7bjeIW/6DQBH1B4c=";
  };
in
{
  home-manager.users.miguvt = { config, ... }: {
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;

        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          "@testpilot-containers" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
            installation_mode = "force_installed";
          };
          "{76ef94a4-e3d0-4c6f-961a-d38a429a332b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ttv-lol-pro/latest.xpi";
            installation_mode = "force_installed";
          };
          "frankerfacez@frankerfacez.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/frankerfacez/latest.xpi";
            installation_mode = "force_installed";
          };
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        Preferences = {
          "browser.aboutConfig.showWarning" = false;
          "browser.compactmode.show" = true;
          "browser.tabs.firefox-view" = false;
        };
      };

      profiles.miguvt = {
        id = 0;
        name = "miguvt";
        isDefault = true;

        search = {
          force = true;
          default = "searxng";
          engines.searxng = {
            name = "SearXNG";
            urls = [
              {
                template = "https://searxng.miguvt.com/search";
                params = [ { name = "q"; value = "{searchTerms}"; } ];
              }
            ];
            icon = "https://searxng.miguvt.com/static/favicon.svg";
            definedAliases = [ "@sx" ];
          };
        };

        extraConfig = ''
          ${builtins.readFile betterfox}

          /****************************************************************************************
          * OPTION: ZEN SMOOTH SCROLLING                                                         *
          ****************************************************************************************/
          // recommended for 120hz+ displays
          user_pref("general.smoothScroll.msdPhysics.enabled", true);
          user_pref("general.smoothScroll.currentVelocityWeighting", "0.15");
          user_pref("general.smoothScroll.stopDecelerationWeighting", "0.6");
          user_pref("mousewheel.min_line_scroll_amount", 10);
          user_pref("general.smoothScroll.mouseWheel.durationMinMS", 80);
          user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
          user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
          user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
          user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
          user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
          user_pref("mousewheel.default.delta_multiplier_y", 200);

          // PREF: restore search engine suggestions
          user_pref("browser.search.suggest.enabled", true);

          // PREF: enable container tabs
          user_pref("privacy.userContext.enabled", true);

          // PREF: disable Firefox Sync
          user_pref("identity.fxaccounts.enabled", false);

          // PREF: disable the Firefox View tour from popping up
          user_pref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");

          // PREF: disable login manager
          user_pref("signon.rememberSignons", false);

          // PREF: disable address and credit card manager
          user_pref("extensions.formautofill.addresses.enabled", false);
          user_pref("extensions.formautofill.creditCards.enabled", false);

          // PREF: hide site shortcut thumbnails on New Tab page
          user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);

          // PREF: hide weather on New Tab page
          user_pref("browser.newtabpage.activity-stream.showWeather", false);

          // PREF: hide dropdown suggestions when clicking on the address bar
          user_pref("browser.urlbar.suggest.topsites", false);

          // PREF: ask where to save every file
          user_pref("browser.download.useDownloadDir", false);

          // PREF: display the installation prompt for all extensions
          user_pref("extensions.postDownloadThirdPartyPrompt", false);
        '';
      };
    };
  };
}
